PYTHON?=python3

build-docker:
	rm -rf oommfc/
	git clone https://github.com/joommf/oommfc.git --depth 1
	docker build -t joommf/tryjoommf .

push-docker: build-docker
	docker push joommf/tryjoommf
