# jmeter-image

JMeter base image to run jmeter by providing any external jmx file.

## Build

```
docker build -t deepaksinghvi/jmeter-image .
```

## Run

- Without any param for jmx file

```
docker run deepaksinghvi/jmeter-image
```
This would use the default jmx file which is https://raw.githubusercontent.com/deepaksinghvi/jmeter-one-off-dyno/main/test/jmeter_on_aws.jmx


- With user provided jmx file
```
docker run deepaksinghvi/jmeter-image https://raw.githubusercontent.com/deepaksinghvi/jmeter-base-image/main/tests/Demo_Test_Plan.jmx
```
This would use the jmx file provided as a param input.

