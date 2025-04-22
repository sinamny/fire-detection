#!/bin/bash
pg_dump -U fire_user -F c -b -v -f "fire_detection_backup_$(date +%F).dump" fire_detection
