CREATE OR REPLACE FUNCTION mark_video_uploaded(video UUID, cloud_path TEXT)
RETURNS VOID AS $$
BEGIN
  UPDATE videos
  SET file_path = cloud_path,
      processing_status = 'pending'
  WHERE video_id = video;
END;
$$ LANGUAGE plpgsql;
