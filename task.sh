#!/bin/bash
sqlite3_rsync ${REMOTE}:${REMOTE_PATH} /backup/replication.db
