CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE fire_intensity_enum AS ENUM ('low', 'medium', 'high', 'extreme');
CREATE TYPE processing_status_enum AS ENUM ('pending', 'processing', 'completed', 'failed');
CREATE TYPE alert_status_enum AS ENUM ('pending', 'sent', 'failed');
CREATE TYPE activity_type_enum AS ENUM ('register','login', 'logout', 'video_upload', 'detection_view', 'alert_view');
CREATE TYPE user_role AS ENUM ('user', 'admin');

CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(512) NOT NULL UNIQUE,
  hashed_password VARCHAR NOT NULL,
  role user_role NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_users_email ON users(email);

CREATE TABLE videos (
    video_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id),
    youtube_url VARCHAR(512) UNIQUE, 
    title VARCHAR(512),
    duration INTEGER NOT NULL, 
    processing_status processing_status_enum DEFAULT 'pending',
    original_filename VARCHAR(512),
    file_path VARCHAR(512), 
    result_video_path VARCHAR(512), 
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_videos_user ON videos(user_id);
CREATE INDEX idx_videos_url ON videos(youtube_url);
CREATE INDEX idx_videos_status ON videos(processing_status);
CREATE INDEX idx_videos_created_at ON videos(created_at);


CREATE TABLE detections (
    detection_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_id UUID NOT NULL REFERENCES videos(video_id),
    frame_timestamp DECIMAL(12,3) NOT NULL, 
    confidence DECIMAL(5,4) NOT NULL,
    fire_intensity fire_intensity_enum, 
    fire_area DECIMAL(10,2), 
    fire_start_time DECIMAL(12,3), 
    bounding_box JSONB NOT NULL, 
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_detections_video ON detections(video_id);
CREATE INDEX idx_detections_timestamp ON detections(frame_timestamp);
CREATE INDEX idx_detections_confidence ON detections(confidence);
CREATE INDEX idx_detections_intensity ON detections(fire_intensity);

CREATE TABLE alerts (
    alert_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    detection_id UUID NOT NULL REFERENCES detections(detection_id),
    user_id UUID NOT NULL REFERENCES users(user_id),
    status alert_status_enum DEFAULT 'pending', 
    sent_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_alerts_detection ON alerts(detection_id);
CREATE INDEX idx_alerts_status ON alerts(status);
CREATE INDEX idx_alerts_created_at ON alerts(created_at);

CREATE TABLE user_activities (
    activity_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(user_id),
    activity_type activity_type_enum NOT NULL,
    activity_details JSONB, 
    created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_activities_user ON user_activities(user_id);
CREATE INDEX idx_activities_type ON user_activities(activity_type);
CREATE INDEX idx_activities_created_at ON user_activities(created_at);
