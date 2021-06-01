FROM centos
RUN yum install -y java
ADD target/my-test-app-0.0.1-SNAPSHOT.jar my-test-app.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","my-test-app.jar"]
