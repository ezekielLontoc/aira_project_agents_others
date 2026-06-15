# POC-1 Approval 500 Tomcat Stack Trace

## Status

CAPTURED

## Date

2026-06-15 17:13:28 +08:00

## Container

- Name: aira-accelerator-security
- ID: 452a80ed4a69
- Ports: 0.0.0.0:9091->8080/tcp, [::]:9091->8080/tcp

## Filtered Error Lines

`	ext
2026-06-15T09:02:22.405Z ERROR 1 --- [accelerator-security] [nio-8080-exec-6] o.s.b.w.servlet.support.ErrorPageFilter  : Forwarding to error page from request [/api/v1/identity/admin/access-requests/1195768b-d383-4ccf-b322-416afd2164a6/approve] due to exception [Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.]
java.lang.IllegalArgumentException: Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:124) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter$1.doFilterInternal(ErrorPageFilter.java:99) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:117) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83) ~[catalina.jar:11.0.22]
2026-06-15T09:06:24.302Z ERROR 1 --- [accelerator-security] [nio-8080-exec-6] o.s.b.w.servlet.support.ErrorPageFilter  : Forwarding to error page from request [/api/v1/identity/admin/access-requests/62d3f176-18b7-4451-a3c5-697ad9699950/approve] due to exception [Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.]
java.lang.IllegalArgumentException: Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:124) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter$1.doFilterInternal(ErrorPageFilter.java:99) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:117) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83) ~[catalina.jar:11.0.22]
2026-06-15T09:11:28.827Z ERROR 1 --- [accelerator-security] [nio-8080-exec-8] o.s.b.w.servlet.support.ErrorPageFilter  : Forwarding to error page from request [/api/v1/identity/admin/access-requests/fd9b5a72-321e-40c2-aa3d-f6ed48eb8e20/approve] due to exception [Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.]
java.lang.IllegalArgumentException: Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:124) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter$1.doFilterInternal(ErrorPageFilter.java:99) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:117) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83) ~[catalina.jar:11.0.22]
`",
",


`	ext
11-Jun-2026 09:53:49.787 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/11.0.22
11-Jun-2026 09:53:49.795 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          May 1 2026 18:29:05 UTC
11-Jun-2026 09:53:49.796 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 11.0.22.0
11-Jun-2026 09:53:49.796 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
11-Jun-2026 09:53:49.796 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            6.6.87.2-microsoft-standard-WSL2
11-Jun-2026 09:53:49.796 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
11-Jun-2026 09:53:49.797 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/java/openjdk
11-Jun-2026 09:53:49.797 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           21.0.11+10-LTS
11-Jun-2026 09:53:49.798 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Eclipse Adoptium
11-Jun-2026 09:53:49.799 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
11-Jun-2026 09:53:49.799 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
11-Jun-2026 09:53:49.816 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
11-Jun-2026 09:53:49.817 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
11-Jun-2026 09:53:49.817 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
11-Jun-2026 09:53:49.818 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
11-Jun-2026 09:53:49.818 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang=ALL-UNNAMED
11-Jun-2026 09:53:49.818 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang.reflect=ALL-UNNAMED
11-Jun-2026 09:53:49.818 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.io=ALL-UNNAMED
11-Jun-2026 09:53:49.818 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util=ALL-UNNAMED
11-Jun-2026 09:53:49.818 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util.concurrent=ALL-UNNAMED
11-Jun-2026 09:53:49.819 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
11-Jun-2026 09:53:49.819 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --enable-native-access=ALL-UNNAMED
11-Jun-2026 09:53:49.819 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
11-Jun-2026 09:53:49.820 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
11-Jun-2026 09:53:49.820 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
11-Jun-2026 09:53:49.826 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded Apache Tomcat Native library [2.0.14] using APR version [1.7.2].
11-Jun-2026 09:53:49.836 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 3.0.13 30 Jan 2024]
11-Jun-2026 09:53:50.431 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
11-Jun-2026 09:53:50.472 INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [1011] milliseconds
11-Jun-2026 09:53:50.532 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
11-Jun-2026 09:53:50.532 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/11.0.22]
11-Jun-2026 09:53:50.563 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/ROOT.war]
11-Jun-2026 09:53:52.930 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v3.5.0)

2026-06-11T09:53:54.101Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Starting AiraAcceleratorSecurityApplication using Java 21.0.11 with PID 1 (/usr/local/tomcat/webapps/ROOT/WEB-INF/classes started by root in /usr/local/tomcat)
2026-06-11T09:53:54.103Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : The following 1 profile is active: "default"
2026-06-11T09:53:56.008Z  INFO 1 --- [accelerator-security] [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1867 ms
2026-06-11T09:54:00.122Z  INFO 1 --- [accelerator-security] [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoints beneath base path '/actuator'
2026-06-11T09:54:00.302Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Started AiraAcceleratorSecurityApplication in 7.121 seconds (process running for 11.155)
11-Jun-2026 09:54:00.359 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/ROOT.war] has finished in [9,795] ms
11-Jun-2026 09:54:00.363 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
11-Jun-2026 09:54:00.376 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [9903] milliseconds
15-Jun-2026 01:10:11.629 INFO [Thread-2] org.apache.coyote.AbstractProtocol.pause Pausing ProtocolHandler ["http-nio-8080"]
15-Jun-2026 08:30:56.169 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/11.0.22
15-Jun-2026 08:30:56.180 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          May 1 2026 18:29:05 UTC
15-Jun-2026 08:30:56.183 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 11.0.22.0
15-Jun-2026 08:30:56.183 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
15-Jun-2026 08:30:56.184 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            6.6.87.2-microsoft-standard-WSL2
15-Jun-2026 08:30:56.184 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
15-Jun-2026 08:30:56.184 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/java/openjdk
15-Jun-2026 08:30:56.184 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           21.0.11+10-LTS
15-Jun-2026 08:30:56.185 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Eclipse Adoptium
15-Jun-2026 08:30:56.185 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
15-Jun-2026 08:30:56.185 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
15-Jun-2026 08:30:56.202 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
15-Jun-2026 08:30:56.202 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
15-Jun-2026 08:30:56.202 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang.reflect=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.io=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util.concurrent=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --enable-native-access=ALL-UNNAMED
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
15-Jun-2026 08:30:56.203 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
15-Jun-2026 08:30:56.204 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
15-Jun-2026 08:30:56.218 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded Apache Tomcat Native library [2.0.14] using APR version [1.7.2].
15-Jun-2026 08:30:56.231 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 3.0.13 30 Jan 2024]
15-Jun-2026 08:30:56.706 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
15-Jun-2026 08:30:56.764 INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [900] milliseconds
15-Jun-2026 08:30:56.846 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
15-Jun-2026 08:30:56.847 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/11.0.22]
15-Jun-2026 08:30:56.876 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/ROOT.war]
15-Jun-2026 08:30:59.349 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v3.5.0)

2026-06-15T08:31:00.707Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Starting AiraAcceleratorSecurityApplication using Java 21.0.11 with PID 1 (/usr/local/tomcat/webapps/ROOT/WEB-INF/classes started by root in /usr/local/tomcat)
2026-06-15T08:31:00.710Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : The following 1 profile is active: "default"
2026-06-15T08:31:02.815Z  INFO 1 --- [accelerator-security] [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 2060 ms
2026-06-15T08:31:06.977Z  INFO 1 --- [accelerator-security] [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoints beneath base path '/actuator'
2026-06-15T08:31:07.194Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Started AiraAcceleratorSecurityApplication in 7.558 seconds (process running for 11.69)
15-Jun-2026 08:31:07.250 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/ROOT.war] has finished in [10,373] ms
15-Jun-2026 08:31:07.255 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
15-Jun-2026 08:31:07.281 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [10518] milliseconds
2026-06-15T08:59:08.829Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2026-06-15T08:59:08.848Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 15 ms
15-Jun-2026 09:02:12.095 INFO [Thread-2] org.apache.coyote.AbstractProtocol.pause Pausing ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:02:12.111 INFO [Thread-2] org.apache.catalina.core.StandardService.stopInternal Stopping service [Catalina]
15-Jun-2026 09:02:12.147 INFO [Thread-2] org.apache.coyote.AbstractProtocol.stop Stopping ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:02:12.155 INFO [Thread-2] org.apache.coyote.AbstractProtocol.destroy Destroying ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:02:13.339 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/11.0.22
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          May 1 2026 18:29:05 UTC
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 11.0.22.0
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            6.6.87.2-microsoft-standard-WSL2
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/java/openjdk
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           21.0.11+10-LTS
15-Jun-2026 09:02:13.345 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Eclipse Adoptium
15-Jun-2026 09:02:13.346 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
15-Jun-2026 09:02:13.346 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
15-Jun-2026 09:02:13.361 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
15-Jun-2026 09:02:13.361 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
15-Jun-2026 09:02:13.361 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
15-Jun-2026 09:02:13.361 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
15-Jun-2026 09:02:13.361 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang.reflect=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.io=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util.concurrent=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --enable-native-access=ALL-UNNAMED
15-Jun-2026 09:02:13.362 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
15-Jun-2026 09:02:13.363 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
15-Jun-2026 09:02:13.364 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
15-Jun-2026 09:02:13.374 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded Apache Tomcat Native library [2.0.14] using APR version [1.7.2].
15-Jun-2026 09:02:13.384 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 3.0.13 30 Jan 2024]
15-Jun-2026 09:02:13.716 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:02:13.744 INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [592] milliseconds
15-Jun-2026 09:02:13.781 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
15-Jun-2026 09:02:13.782 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/11.0.22]
15-Jun-2026 09:02:13.797 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/ROOT.war]
15-Jun-2026 09:02:15.145 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v3.5.0)

2026-06-15T09:02:15.711Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Starting AiraAcceleratorSecurityApplication using Java 21.0.11 with PID 1 (/usr/local/tomcat/webapps/ROOT/WEB-INF/classes started by root in /usr/local/tomcat)
2026-06-15T09:02:15.712Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : The following 1 profile is active: "default"
2026-06-15T09:02:16.557Z  INFO 1 --- [accelerator-security] [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 828 ms
2026-06-15T09:02:17.564Z  INFO 1 --- [accelerator-security] [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoints beneath base path '/actuator'
2026-06-15T09:02:17.630Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Started AiraAcceleratorSecurityApplication in 2.356 seconds (process running for 4.807)
15-Jun-2026 09:02:17.663 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/ROOT.war] has finished in [3,866] ms
15-Jun-2026 09:02:17.666 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:02:17.675 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [3930] milliseconds
2026-06-15T09:02:20.989Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2026-06-15T09:02:20.990Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 1 ms
2026-06-15T09:02:21.025Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] com.zaxxer.hikari.HikariDataSource       : accelerator-security-pool - Starting...
2026-06-15T09:02:21.040Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] com.zaxxer.hikari.HikariDataSource       : accelerator-security-pool - Start completed.
2026-06-15T09:02:22.405Z ERROR 1 --- [accelerator-security] [nio-8080-exec-6] o.s.b.w.servlet.support.ErrorPageFilter  : Forwarding to error page from request [/api/v1/identity/admin/access-requests/1195768b-d383-4ccf-b322-416afd2164a6/approve] due to exception [Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.]

java.lang.IllegalArgumentException: Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.updateNamedValueInfo(AbstractNamedValueMethodArgumentResolver.java:186) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.getNamedValueInfo(AbstractNamedValueMethodArgumentResolver.java:161) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.resolveArgument(AbstractNamedValueMethodArgumentResolver.java:107) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.HandlerMethodArgumentResolverComposite.resolveArgument(HandlerMethodArgumentResolverComposite.java:122) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.InvocableHandlerMethod.getMethodArgumentValues(InvocableHandlerMethod.java:227) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:181) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:118) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:986) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:891) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1089) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:979) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1014) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:914) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:649) ~[servlet-api.jar:6.1]
	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:885) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:710) ~[servlet-api.jar:6.1]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:128) ~[catalina.jar:11.0.22]
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53) ~[tomcat-websocket.jar:11.0.22]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.ServerHttpObservationFilter.doFilterInternal(ServerHttpObservationFilter.java:114) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:124) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter$1.doFilterInternal(ErrorPageFilter.java:99) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:117) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:77) ~[catalina.jar:11.0.22]
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:492) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113) ~[catalina.jar:11.0.22]
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83) ~[catalina.jar:11.0.22]
	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:782) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72) ~[catalina.jar:11.0.22]
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:341) ~[catalina.jar:11.0.22]
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:397) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:1272) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1801) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:946) ~[tomcat-util.jar:11.0.22]
	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:480) ~[tomcat-util.jar:11.0.22]
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:57) ~[tomcat-util.jar:11.0.22]
	at java.base/java.lang.Thread.run(Thread.java:1583) ~[na:na]

15-Jun-2026 09:06:13.910 INFO [Thread-2] org.apache.coyote.AbstractProtocol.pause Pausing ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:06:13.913 INFO [Thread-2] org.apache.catalina.core.StandardService.stopInternal Stopping service [Catalina]
15-Jun-2026 09:06:13.930 WARNING [Thread-2] org.apache.catalina.loader.WebappClassLoaderBase.clearReferencesThreads The web application [ROOT] appears to have started a thread named [accelerator-security-pool:housekeeper] but has failed to stop it. This is very likely to create a memory leak. Stack trace of thread:
 java.base/jdk.internal.misc.Unsafe.park(Native Method)
 java.base/java.util.concurrent.locks.LockSupport.parkNanos(LockSupport.java:269)
 java.base/java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.awaitNanos(AbstractQueuedSynchronizer.java:1797)
 java.base/java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(ScheduledThreadPoolExecutor.java:1182)
 java.base/java.util.concurrent.ScheduledThreadPoolExecutor$DelayedWorkQueue.take(ScheduledThreadPoolExecutor.java:899)
 java.base/java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1070)
 java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1130)
 java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:642)
 java.base/java.lang.Thread.run(Thread.java:1583)
15-Jun-2026 09:06:13.961 INFO [Thread-2] org.apache.coyote.AbstractProtocol.stop Stopping ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:06:13.970 INFO [Thread-2] org.apache.coyote.AbstractProtocol.destroy Destroying ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:06:15.032 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/11.0.22
15-Jun-2026 09:06:15.038 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          May 1 2026 18:29:05 UTC
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 11.0.22.0
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            6.6.87.2-microsoft-standard-WSL2
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/java/openjdk
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           21.0.11+10-LTS
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Eclipse Adoptium
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
15-Jun-2026 09:06:15.039 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
15-Jun-2026 09:06:15.053 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
15-Jun-2026 09:06:15.053 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
15-Jun-2026 09:06:15.053 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
15-Jun-2026 09:06:15.053 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
15-Jun-2026 09:06:15.054 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang=ALL-UNNAMED
15-Jun-2026 09:06:15.054 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.lang.reflect=ALL-UNNAMED
15-Jun-2026 09:06:15.054 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.io=ALL-UNNAMED
15-Jun-2026 09:06:15.054 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util=ALL-UNNAMED
15-Jun-2026 09:06:15.054 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.base/java.util.concurrent=ALL-UNNAMED
15-Jun-2026 09:06:15.054 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED
15-Jun-2026 09:06:15.055 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: --enable-native-access=ALL-UNNAMED
15-Jun-2026 09:06:15.055 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
15-Jun-2026 09:06:15.055 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
15-Jun-2026 09:06:15.055 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
15-Jun-2026 09:06:15.062 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded Apache Tomcat Native library [2.0.14] using APR version [1.7.2].
15-Jun-2026 09:06:15.068 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 3.0.13 30 Jan 2024]
15-Jun-2026 09:06:15.370 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:06:15.396 INFO [main] org.apache.catalina.startup.Catalina.load Server initialization in [577] milliseconds
15-Jun-2026 09:06:15.434 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
15-Jun-2026 09:06:15.434 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/11.0.22]
15-Jun-2026 09:06:15.449 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/ROOT.war]
15-Jun-2026 09:06:16.806 INFO [main] org.apache.jasper.servlet.TldScanner.scanJars At least one JAR was scanned for TLDs yet contained no TLDs. Enable debug logging for this logger for a complete list of JARs that were scanned but no TLDs were found in them. Skipping unneeded JARs during scanning can improve startup time and JSP compilation time.

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v3.5.0)

2026-06-15T09:06:17.621Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Starting AiraAcceleratorSecurityApplication using Java 21.0.11 with PID 1 (/usr/local/tomcat/webapps/ROOT/WEB-INF/classes started by root in /usr/local/tomcat)
2026-06-15T09:06:17.626Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : The following 1 profile is active: "default"
2026-06-15T09:06:18.692Z  INFO 1 --- [accelerator-security] [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1028 ms
2026-06-15T09:06:19.790Z  INFO 1 --- [accelerator-security] [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 2 endpoints beneath base path '/actuator'
2026-06-15T09:06:19.850Z  INFO 1 --- [accelerator-security] [           main] a.a.s.AiraAcceleratorSecurityApplication : Started AiraAcceleratorSecurityApplication in 2.834 seconds (process running for 5.305)
15-Jun-2026 09:06:19.880 INFO [main] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/ROOT.war] has finished in [4,430] ms
15-Jun-2026 09:06:19.886 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
15-Jun-2026 09:06:19.896 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in [4498] milliseconds
2026-06-15T09:06:22.763Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2026-06-15T09:06:22.764Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 1 ms
2026-06-15T09:06:22.810Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] com.zaxxer.hikari.HikariDataSource       : accelerator-security-pool - Starting...
2026-06-15T09:06:22.825Z  INFO 1 --- [accelerator-security] [nio-8080-exec-1] com.zaxxer.hikari.HikariDataSource       : accelerator-security-pool - Start completed.
2026-06-15T09:06:24.302Z ERROR 1 --- [accelerator-security] [nio-8080-exec-6] o.s.b.w.servlet.support.ErrorPageFilter  : Forwarding to error page from request [/api/v1/identity/admin/access-requests/62d3f176-18b7-4451-a3c5-697ad9699950/approve] due to exception [Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.]

java.lang.IllegalArgumentException: Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.updateNamedValueInfo(AbstractNamedValueMethodArgumentResolver.java:186) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.getNamedValueInfo(AbstractNamedValueMethodArgumentResolver.java:161) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.resolveArgument(AbstractNamedValueMethodArgumentResolver.java:107) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.HandlerMethodArgumentResolverComposite.resolveArgument(HandlerMethodArgumentResolverComposite.java:122) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.InvocableHandlerMethod.getMethodArgumentValues(InvocableHandlerMethod.java:227) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:181) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:118) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:986) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:891) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1089) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:979) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1014) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:914) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:649) ~[servlet-api.jar:6.1]
	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:885) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:710) ~[servlet-api.jar:6.1]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:128) ~[catalina.jar:11.0.22]
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53) ~[tomcat-websocket.jar:11.0.22]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.ServerHttpObservationFilter.doFilterInternal(ServerHttpObservationFilter.java:114) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:124) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter$1.doFilterInternal(ErrorPageFilter.java:99) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:117) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:77) ~[catalina.jar:11.0.22]
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:492) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113) ~[catalina.jar:11.0.22]
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83) ~[catalina.jar:11.0.22]
	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:782) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72) ~[catalina.jar:11.0.22]
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:341) ~[catalina.jar:11.0.22]
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:397) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:1272) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1801) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:946) ~[tomcat-util.jar:11.0.22]
	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:480) ~[tomcat-util.jar:11.0.22]
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:57) ~[tomcat-util.jar:11.0.22]
	at java.base/java.lang.Thread.run(Thread.java:1583) ~[na:na]

2026-06-15T09:11:28.827Z ERROR 1 --- [accelerator-security] [nio-8080-exec-8] o.s.b.w.servlet.support.ErrorPageFilter  : Forwarding to error page from request [/api/v1/identity/admin/access-requests/fd9b5a72-321e-40c2-aa3d-f6ed48eb8e20/approve] due to exception [Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.]

java.lang.IllegalArgumentException: Name for argument of type [java.util.UUID] not specified, and parameter name information not available via reflection. Ensure that the compiler uses the '-parameters' flag.
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.updateNamedValueInfo(AbstractNamedValueMethodArgumentResolver.java:186) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.getNamedValueInfo(AbstractNamedValueMethodArgumentResolver.java:161) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.annotation.AbstractNamedValueMethodArgumentResolver.resolveArgument(AbstractNamedValueMethodArgumentResolver.java:107) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.HandlerMethodArgumentResolverComposite.resolveArgument(HandlerMethodArgumentResolverComposite.java:122) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.InvocableHandlerMethod.getMethodArgumentValues(InvocableHandlerMethod.java:227) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:181) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:118) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:986) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:891) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:87) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:1089) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:979) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:1014) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at org.springframework.web.servlet.FrameworkServlet.doPost(FrameworkServlet.java:914) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:649) ~[servlet-api.jar:6.1]
	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:885) ~[spring-webmvc-6.2.7.jar:6.2.7]
	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:710) ~[servlet-api.jar:6.1]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:128) ~[catalina.jar:11.0.22]
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53) ~[tomcat-websocket.jar:11.0.22]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.RequestContextFilter.doFilterInternal(RequestContextFilter.java:100) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.FormContentFilter.doFilterInternal(FormContentFilter.java:93) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.ServerHttpObservationFilter.doFilterInternal(ServerHttpObservationFilter.java:114) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:124) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter$1.doFilterInternal(ErrorPageFilter.java:99) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.boot.web.servlet.support.ErrorPageFilter.doFilter(ErrorPageFilter.java:117) ~[spring-boot-3.5.0.jar:3.5.0]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:201) ~[spring-web-6.2.7.jar:6.2.7]
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:116) ~[spring-web-6.2.7.jar:6.2.7]
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:107) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:77) ~[catalina.jar:11.0.22]
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:492) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113) ~[catalina.jar:11.0.22]
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83) ~[catalina.jar:11.0.22]
	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:782) ~[catalina.jar:11.0.22]
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72) ~[catalina.jar:11.0.22]
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:341) ~[catalina.jar:11.0.22]
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:397) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:1272) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1801) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52) ~[tomcat-coyote.jar:11.0.22]
	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:946) ~[tomcat-util.jar:11.0.22]
	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:480) ~[tomcat-util.jar:11.0.22]
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:57) ~[tomcat-util.jar:11.0.22]
	at java.base/java.lang.Thread.run(Thread.java:1583) ~[na:na]

`",
",


Use the stack trace above to repair the exact approval endpoint failure. Do not begin POC-1 Phase 3 until approval, login, session, and landing route all pass.