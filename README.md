# Java upgrade example errors and solutions
This project shows the errors encountered during a Java upgrade and the necessary fixes. 

Per Java version there is a Maven module to show what went wrong starting in that version and how it can be fixed.

This project uses Maven, however the issues will be the same with other buildtools.

This readme first describes the issues and solutions for each Java version. After that the various ways to run multiple JDK's on one machine are described.

# Issues and solutions per Java version
## Java 11
### JEP 320: Remove the Java EE and CORBA Modules
The EE packages were removed in Java 11. If you still need them, you can add them as Maven/Gradle dependencies.

**Please be aware that you should use the new jakarta packages as the old packages are no longer updated.**

For instance JAXB can be added with the dependency listed below. However, it's no longer updated, the latest version is 2.3.0.
```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.0</version>
</dependency>
```
You should instead use the Jakarta dependency which has the newer 3.0.0 version.
```xml
<dependency>
    <groupId>jakarta.xml.bind</groupId>
    <artifactId>jakarta.xml.bind-api</artifactId>
    <version>3.0.0</version>
</dependency>
```
#### Removal of javax.activation

##### Example error
```bash
package javax.activation does not exist
```
```bash
cannot find symbol
[ERROR]   symbol:   class URLDataSource
```
##### Solution
Add the necessary dependencies:
```xml
<dependency>
    <groupId>com.sun.activation</groupId>
    <artifactId>jakarta.activation</artifactId>
    <version>2.0.1</version>
</dependency>
```
#### Removal of javax.annotation

##### Example error
```bash
package javax.annotation does not exist
```
```bash
cannot find symbol
[ERROR]   symbol:   class PostConstruct
```
##### Solution
Add the necessary dependencies:
```xml
<dependency>
    <groupId>jakarta.annotation</groupId>
    <artifactId>jakarta.annotation-api</artifactId>
    <version>2.0.0</version>
</dependency>
```
#### Removal of javax.transaction

##### Example error
```bash
package javax.transaction does not exist
```
```bash
cannot find symbol
[ERROR]   symbol:   class TransactionRequiredException
```
##### Solution
Add the necessary dependencies:
```xml
<dependency>
    <groupId>jakarta.transaction</groupId>
    <artifactId>jakarta.transaction-api</artifactId>
    <version>2.0.0</version>
</dependency>
```

#### Removal of javax.xml.bind
##### Example error
```bash
package javax.xml.bind.annotation does not exist
```
```bash
cannot find symbol
[ERROR]   symbol: class XmlRootElement
```
```bash
cannot find symbol
[ERROR]   symbol:   class JAXBException
```
##### Solution
Add the necessary dependencies:
```xml
<dependency>
    <groupId>jakarta.xml.bind</groupId>
    <artifactId>jakarta.xml.bind-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>com.sun.xml.bind</groupId>
    <artifactId>jaxb-impl</artifactId>
    <version>3.0.0</version>
    <scope>runtime</scope>
</dependency>
```

#### Removal of javax.jws javax.xml.soap javax.xml.ws

##### Example error
```bash
package javax.xml.ws does not exist
```
```bash
cannot find symbol
[ERROR]   symbol:   class Service
```
##### Solution
Add the necessary dependencies:
```xml
<dependency>
    <groupId>jakarta.xml.ws</groupId>
    <artifactId>jakarta.xml.ws-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>com.sun.xml.ws</groupId>
    <artifactId>jaxws-rt</artifactId>
    <version>3.0.0</version>
</dependency>
```
#### Removal of Corba javax.activity javax.rmi.*
There's no official replacement/dependency released for Corba
#### Solution
Migrate away from Corba or use something like glassfish-corba

### Font removal
The JDK contained some fonts, but they were removed in Java 11. If the application used these fonts and the operating system doesn't provide them, then an error occurs.

More info from [Azul](https://www.azul.com/the-font-of-all-knowledge-about-java-and-fonts/) and [AdoptOpenJDK](https://blog.adoptopenjdk.net/2021/01/prerequisites-for-font-support-in-adoptopenjdk/)

#### Example errors
```bash
java.lang.UnsatisfiedLinkError: /usr/local/openjdk-11/lib/libfontmanager.so: 
  libfreetype.so.6: cannot open shared object file: No such file or directory
```

```bash
java.lang.NoClassDefFoundError: Could not initialize class sun.awt.X11FontManager
```

#### Solution
Install the necessary fonts, for instance with:
```
apt install fontconfig
```

Depending on your [scenario](https://blog.adoptopenjdk.net/2021/01/prerequisites-for-font-support-in-adoptopenjdk/) you might need to add some extra packages such as: libfreetype6 fontconfig fonts-dejavu.

Some JDK's automatically install the needed packages.

### JavaFX removal
JavaFX is removed from the JDK and continued as OpenJFX.

Some vendors offer builds of OpenJFX such as [Gluon](https://gluonhq.com/products/javafx/)

Some vendors offer JDK builds which include OpenJFX such as [Liberica's full version](https://bell-sw.com/pages/products/) and [ojdkbuild](https://github.com/ojdkbuild/ojdkbuild/wiki/Motivation)

## Java 15
### JEP 372: Remove the Nashorn JavaScript Engine
Nashorn is no longer included in the standard JDK.

#### Solution
Add the necessary dependencies:
```xml
<dependency>
    <groupId>org.openjdk.nashorn</groupId>
    <artifactId>nashorn-core</artifactId>
    <version>15.2</version>
</dependency>
```

## Java 16
### JEP 396: Strongly Encapsulate JDK Internals by Default
Internals of the JDK can no longer be used by default. This mainly impacts tooling which uses low level features of the JDK.

#### Example errors
```bash
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project broken: Fatal error compiling: java.lang.IllegalAccessError: class lombok.javac.apt.LombokProcessor (in unnamed module @0x21bd20ee) cannot access class com.sun.tools.javac.processing.JavacProcessingEnvironment (in module jdk.compiler) because module jdk.compiler does not export com.sun.tools.javac.processing to unnamed module @0x21bd20ee -> [Help 1]
```

#### Solution
Preferably use a new version of the dependency which causes the issue. For instance Lombok 1.18.20 includes support for Java 16:
```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.20</version>
    <scope>provided</scope>
</dependency>
```

If there's no new dependency available it's possible to open up the JDK internals, so they can be used. However, this is not the prettiest solution:
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>3.8.1</version>
    <configuration>
        <fork>true</fork>
        <compilerArgs>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.comp=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.main=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.model=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.processing=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED</arg>
            <arg>-J--add-opens=jdk.compiler/com.sun.tools.javac.jvm=ALL-UNNAMED</arg>
        </compilerArgs>
    </configuration>
</plugin>
```

# Running multiple JDK's on one machine

## Set JAVA_HOME before running an example
The value of `JAVA_HOME` is used by Maven to select the JDK.

Display the current `JAVA_HOME`
```bash
echo $JAVA_HOME
C:\Program Files\AdoptOpenJDK\jdk-16.0.0.36-hotspot
```

Set `JAVA_HOME` to another JDK:
```bash
JAVA_HOME="[location of JDK]"
```

Then use the following Maven command inside one of the Java directories (java11, java16...) to build all submodules and continue when something goes wrong:
```bash
mvn compile --fail-at-end -Dmaven.compiler.release=[Specify JDK version. Don't use this on Java 8 as it's not supported]
```
Or the shorter version:
```bash
mvn compile -fae -Dmaven.compiler.release=[Specify JDK version. Don't use this on Java 8 as it's not supported]
```
The version of the script for Java 8
```bash
mvn compile -fae -Dmaven.compiler.target=8 -Dmaven.compiler.source=8
```
Or change the Maven releases in the `pom.xml`:
```xml
<properties>
    <maven.compiler.release>7</maven.compiler.release>
</properties>
```

## Using Docker containers
Then use the following Docker command inside one of the Java directories (java11, java16...):

```shell script
docker build -t javaupgrades -f ..\Dockerfile --build-arg DISABLE_CACHE="%date%-%time%" --build-arg JDK_VERSION=16 .
```

Or to build on Java 8, which requires a different configuration:
```shell script
docker build -t javaupgrades -f ..\DockerfileJava8 --build-arg DISABLE_CACHE="%date%-%time%" .
```


## Maven Toolchains
**Please read until the end, for now I don't recommend the Maven toolchains as there appears to be a bug.**

Maven Toolchains can be used to configure the JDK's present on your machine and then select one to use in the `pom.xml` of the project.

First create a `toolchains.xml` located in *${user.home}/.m2/*

```xml
<?xml version="1.0" encoding="UTF8"?>
<toolchains>
    <toolchain>
        <type>jdk</type>
        <provides>
            <version>8</version>
        </provides>
        <configuration>
            <jdkHome>/path/to/jdk/8</jdkHome>
        </configuration>
    </toolchain>
    <toolchain>
        <type>jdk</type>
        <provides>
            <version>11</version>
        </provides>
        <configuration>
            <jdkHome>/path/to/jdk/11</jdkHome>
        </configuration>
    </toolchain>
    <toolchain>
        <type>jdk</type>
        <provides>
            <version>16</version>
        </provides>
        <configuration>
            <jdkHome>/path/to/jdk/16</jdkHome>
        </configuration>
    </toolchain>
    <toolchain>
        <type>jdk</type>
        <provides>
            <version>17</version>
        </provides>
        <configuration>
            <jdkHome>/path/to/jdk/16</jdkHome>
        </configuration>
    </toolchain>
</toolchains>
```

Then in the `pom.xml` configure which JDK from the toolchains.xml you want to use:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-toolchains-plugin</artifactId>
            <version>3.0.0</version>
            <configuration>
                <toolchains>
                    <jdk>
                        <version>${maven.compiler.release}</version>
                    </jdk>
                </toolchains>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>toolchain</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

Unfortunately currently there seems to be a bug as building the project with the toolchain gives:
```shell script
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project broken: Compilation failure -> [Help 1]
```

While compiling without the toolchain gives the more descriptive error message:
```shell script
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.8.1:compile (default-compile) on project broken: Fatal error compiling: java.lang.IllegalAccessError: class lombok.javac.apt.LombokProcessor (in unnamed module @0x21bd20ee) cannot access class com.sun.tools.javac.processing.JavacProcessingEnvironment (in module jdk.compiler) because module jdk.compiler does not export com.sun.tools.javac.processing to unnamed module @0x21bd20ee -> [Help 1]
```

So I don't recommend the usage of Maven Toolchains for upgrading to Java 16 or 17 at this point in time.