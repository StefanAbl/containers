FROM jellyfin/jellyfin:10.9.2

ENV jfroot="/jellyfin/jellyfin-web"

COPY images /images

RUN sed -i "s~Jellyfin~Stream~g" $jfroot/manifest.json &&\
    sed -i "s~Jellyfin~Stream~g" $jfroot/index.html &&\
    cp $jfroot/main.*.bundle.js ~/main.bundle.js.bak &&\
    sed -i 's/"Jellyfin"/"Stream"/g' "$(find $jfroot  -type f -name 'main.*.bundle.js')" &&\
    echo "Replacing Images" &&\
    cp /images/favicon.png $jfroot  &&\
    cp /images/touchicon.png $jfroot &&\
    cp /images/touchicon72.png $jfroot &&\
    cp /images/touchicon114.png $jfroot &&\
    cp /images/touchicon144.png $jfroot &&\
    cp /images/touchicon512.png $jfroot  &&\
    cp /images/favicon.ico $jfroot/ && \
    cp /images/logo-notext440.png $jfroot/assets/img/badge.png && \
    cp /images/logo-notext440.png $jfroot/assets/img/notificationicon.png && \
    cp /images/logo.png $jfroot/assets/img/banner-light.png && \
    cp /images/logo.png $jfroot/assets/img/banner-dark.png && \
    cp /images/touchicon512.png $jfroot/assets/img/icon-transparent.png &&\
    rm -rf /images
