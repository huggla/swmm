ARG TAG="20190418"
ARG DESTDIR="/swmm"

FROM huggla/alpine as alpine

ARG BUILDDEPS="build-base"
ARG DOWNLOAD="https://www.epa.gov/sites/production/files/2018-08/swmm51013_engine_0.zip"
ARG CFLAGS="-Os -fomit-frame-pointer -mcmodel=large"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget "$DOWNLOAD" \
 && unzip $(basename "$DOWNLOAD") \
 && unzip makefiles.zip \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && unzip "$downloadDir/source5_1_013.zip" \
 && unzip -o "$downloadDir/GNU-LIB.zip" \
 && rm -rf $downloadDir \
 && make \
 && cc -L ./ -o swmm5 main.c -lswmm5 \
 && mkdir -p $DESTDIR/usr/lib $DESTDIR/usr/bin \
 && cp -a libswmm5.so $DESTDIR/usr/lib/ \
 && cp -a swmm5 $DESTDIR/usr/bin/

FROM huggla/busybox:$TAG as image

ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
