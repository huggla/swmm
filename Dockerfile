ARG TAG="20181204"
ARG DESTDIR="/swmm5"

FROM huggla/alpine-official:$TAG as alpine

ARG BUILDDEPS="build-base wget"
ARG DOWNLOAD="https://www.epa.gov/sites/production/files/2018-08/swmm51013_engine_0.zip"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget --no-check-certificate "$DOWNLOAD" \
 && unzip $(basename "$DOWNLOAD") \
 && unzip makefiles.ZIP \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && unzip "$downloadDir/source5_1_013.zip" \
 && unzip -o "$downloadDir/GNU-LIB.ZIP" \
 && rm -rf $downloadDir \
 && make \
 && cc -o "$DESTDIR/swmm5" main.c -lswmm5

FROM huggla/busybox:$TAG as image

ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
