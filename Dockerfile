FROM ubuntu:16.04


RUN apt-get update && \
	apt-get install supervisor && \
	mkdir /var/log/supervisor

RUN useradd --shell /bin/false prometheus && \
	useradd --no-create-home --shell /bin/false node_exporter && \
	mkdir /etc/prometheus && \
	mkdir /var/lib/prometheus && \
	chown prometheus:prometheus /etc/prometheus && \
	chown prometheus:prometheus /var/lib/prometheus

RUN mkdir /usr/src && \
	cd /usr/src && \
	wget https://github.com/prometheus/prometheus/releases/download/v2.0.0/prometheus-2.0.0.linux-amd64.tar.gz && \
	tar xvf prometheus-2.0.0.linux-amd64.tar.gz && \
	rm prometheus-2.0.0.linux-amd64.tar.gz && \
	cp prometheus-2.0.0.linux-amd64/prometheus /usr/local/bin/ && \
	cp prometheus-2.0.0.linux-amd64/promtool /usr/local/bin/ && \
	chown prometheus:prometheus /usr/local/bin/prometheus && \
	chown prometheus:prometheus /usr/local/bin/promtool && \
	cp -r prometheus-2.0.0.linux-amd64/consoles /etc/prometheus && \
	cp -r prometheus-2.0.0.linux-amd64/console_libraries /etc/prometheus && \
	chown -R prometheus:prometheus /etc/prometheus/consoles && \
	chown -R prometheus:prometheus /etc/prometheus/console_libraries && \
	wget https://github.com/prometheus/node_exporter/releases/download/v0.15.1/node_exporter-0.15.1.linux-amd64.tar.gz && \
	tar xvf node_exporter-0.15.1.linux-amd64.tar.gz && \
	rm node_exporter-0.15.1.linux-amd64.tar.gz && \
	cp node_exporter-0.15.1.linux-amd64/node_exporter /usr/local/bin && \
	chown node_exporter:node_exporter /usr/local/bin/node_exporter

COPY ./prometheus.yml /etc/prometheus/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9090 9091 3000 8080
CMD ["/usr/bin/supervisord"]

