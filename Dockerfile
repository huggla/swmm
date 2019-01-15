ARG TAG="20190115"
ARG DESTDIR="/swmm"

FROM huggla/alpine-official as alpine

ARG BUILDDEPS="build-base wget"
ARG DOWNLOAD="https://www.epa.gov/sites/production/files/2018-08/swmm51013_engine_0.zip"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget --no-check-certificate "$DOWNLOAD" \
 && unzip $(basename "$DOWNLOAD") \
 && unzip makefiles.zip \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && unzip "$downloadDir/source5_1_013.zip" \
 && unzip -o "$downloadDir/GNU-LIB.zip" \
 && rm -rf $downloadDir \
# && sed -i 's/cc -o libswmm5.so $(objs) -fopenmp -lm -lpthread -shared/cc -fPIC -o libswmm5.so $(objs) -fopenmp -lm -lpthread -shared/' Makefile \
# && cat Makefile \
 && cc -o swmm5 main.c -lswmm5 \
 && make

#FROM huggla/busybox:$TAG as image

#ARG DESTDIR

#COPY --from=alpine $DESTDIR $DESTDIR
