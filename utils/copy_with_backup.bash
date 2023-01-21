function copy_with_backup() {
  COPY_SOURCE_FILE="$1"
  COPY_DESTINATION_FILE="$2"

  if [ -e "$COPY_DESTINATION_FILE" ]; then
    cp "$COPY_DESTINATION_FILE" "$COPY_DESTINATION_FILE.$(date +%Y%m%d-%H%M%S).back"
  fi
  cp "$COPY_SOURCE_FILE" "$COPY_DESTINATION_FILE"
}
