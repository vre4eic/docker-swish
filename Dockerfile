FROM swipl as base

RUN apt-get update && apt-get install -y \
    git build-essential autoconf curl unzip \
    cleancss node-requirejs

ENV SWISH_HOME /swish
ENV SWISH_SHA1 V1.1.0

RUN echo "At version ${SWISH_SHA1}"
RUN git clone https://github.com/vre4eic/swish.git ${SWISH_HOME} && \
    (cd swish && git checkout -q ${SWISH_SHA1})

RUN make -C /swish RJS="nodejs /usr/lib/nodejs/requirejs/r.js" \
	bower-zip packs min

FROM base
LABEL maintainer "Jan Wielemaker <jan@swi-prolog.org>",  "Jacco van Ossenbruggen <Jacco.van.Ossenbruggen@cwi.nl>"

RUN apt-get update && apt-get install -y \
    graphviz imagemagick \
    git \
    wamerican && \
    rm -rf /var/lib/apt/lists/*

COPY --from=base /swish /swish
COPY entry.sh /entry.sh

ENV SWISH_DATA /data
VOLUME ${SWISH_DATA}
WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/entry.sh"]
