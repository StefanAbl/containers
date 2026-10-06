FROM jellyfin/jellyfin:12.2


RUN apt update && apt install -y sqlite3

COPY images /images
COPY customize.sh /customize.sh

RUN bash /customize.sh
