FROM swipl as base

RUN apt-get update && apt-get install -y \
    git build-essential autoconf curl unzip \
    cleancss node-requirejs

ENV SWISH_HOME /swish
ENV SWISH_SHA1 3a7e413149e68f2500aa0575465c70e8a1b5e53f

RUN echo "At version ${SWISH_SHA1}"
RUN git clone https://github.com/vre4eic/swish.git && \
    (cd swish && git checkout -q ${SWISH_SHA1})
RUN make -C /swish RJS="nodejs /usr/lib/nodejs/requirejs/r.js" \
	bower-zip packs min

FROM base
LABEL maintainer "Jan Wielemaker <jan@swi-prolog.org>",  "Jacco van Ossenbruggen <Jacco.van.Ossenbruggen@cwi.nl>"

RUN apt-get update && apt-get install -y \
    graphviz imagemagick \
    wamerican && \
    rm -rf /var/lib/apt/lists/*

COPY --from=base /swish /swish
COPY entry.sh entry.sh

ENV SWISH_DATA /data
VOLUME ${SWISH_DATA}
WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/entry.sh"]
