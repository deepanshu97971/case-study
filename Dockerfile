FROM centos
RUN yum install -y java
ADD target/bootcamp-0.0.1-SNAPSHOT.jar bootcamp-app.jar
EXPOSE 8888
ENTRYPOINT ["java","-jar","bootcamp-app.jar"]
