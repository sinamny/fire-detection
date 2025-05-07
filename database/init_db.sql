CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TYPE user_role AS ENUM ('user', 'admin');
CREATE TYPE processing_status_enum AS ENUM ('pending', 'processing', 'completed', 'failed');
CREATE TYPE alert_status_enum AS ENUM ('pending', 'sent', 'failed');

CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL UNIQUE,
  hashed_password VARCHAR(255) NOT NULL,
  role user_role NOT NULL DEFAULT 'user',
  address VARCHAR(255),
  created_at TIMESTAMP DEFAULT now(),
  email_notifications_enabled BOOLEAN DEFAULT TRUE,
  screen_alerts_enabled BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_users_email ON users(email);

CREATE TABLE videos (
  video_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id),
  youtube_url VARCHAR(255) UNIQUE,
  title VARCHAR(255),
  duration INTEGER NOT NULL,
  processing_status processing_status_enum NOT NULL DEFAULT 'pending',
  original_filename VARCHAR(255),
  file_path VARCHAR(255),
  result_video_path VARCHAR(255),
  created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_videos_user ON videos(user_id);
CREATE INDEX idx_videos_url ON videos(youtube_url);
CREATE INDEX idx_videos_status ON videos(processing_status);
CREATE INDEX idx_videos_created_at ON videos(created_at);

CREATE TABLE fire_alerts (
  alert_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  video_id UUID NOT NULL REFERENCES videos(video_id),
  user_id UUID NOT NULL REFERENCES users(user_id),
  alert_type VARCHAR(20) NOT NULL,
  alert_status alert_status_enum NOT NULL DEFAULT 'pending',
  sent_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT now()
);

CREATE INDEX idx_fire_alerts_user ON fire_alerts(user_id);
CREATE INDEX idx_fire_alerts_status ON fire_alerts(alert_status);

CREATE TABLE video_summary (
  video_id UUID PRIMARY KEY REFERENCES videos(video_id),
  fire_start_time DECIMAL(12,3),
  fire_end_time DECIMAL(12,3),
  max_fire_frame INTEGER,
  max_fire_frame_image_path VARCHAR(255)
);

CREATE INDEX idx_video_summary_video ON video_summary(video_id);
