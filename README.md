**NO BORRAR REPO AL MENOS POR UN AÑO, EXPIRES TO: 20-12-2026**

**Contexto de la evaluación**:

Esta evaluación, correspondiente al Aseguramiento de la Calidad del Software, se centra en la implementación práctica de un flujo de trabajo automatizado. El ejercicio requiere la construcción de un repositorio que integre un pipeline de Integración y Despliegue Continuo (CI/CD) utilizando GitHub y GitHub Actions. La actividad simula un entorno de desarrollo ágil donde se deben garantizar elementos clave de calidad, desde la contenerización de la aplicación hasta la validación de seguridad antes del despliegue.

**Objetivo del documento**:

El propósito de este documento es evidenciar el diseño y la implementación técnica de los pipelines de CI/CD solicitados, demostrando la capacidad para automatizar la compilación, prueba y despliegue de software.

Este entregable detalla la ejecución práctica realizada para cumplir con los siguientes hitos:

- Automatización y Contenerización: Configuración de GitHub Actions para la construcción de imágenes Docker, ejecución de pruebas unitarias dentro del contenedor y publicación en Docker Hub.

- Análisis Estático de Código: Integración de herramientas como SonarCloud y Snyk en el pipeline para asegurar la calidad del código en cada pull request.

- Seguridad Avanzada y de Contenedores: Implementación de escaneos de seguridad mediante GitHub Advanced Security (dependencias y secretos) y Docker Scout para la detección de vulnerabilidades en las imágenes.

- Control de Flujo de Trabajo: Configuración de reglas de despliegue y bloqueos automáticos ante la detección de problemas críticos de seguridad o calidad.

- **AUTOMATIZACIÓN CON GITHUB ACTIONS Y DOCKER**

**Requerimientos**

- **Dockerizar la App:** Se crea un archivo Dockerfile.
- **Pipeline CI/CD (GitHub Actions):**
  - **Disparadores:** se realiza push a la rama develop y pull request a main.
  - **Pasos:**
    - Construir una imagen Docker.
    - Correr pruebas unitarias **dentro** del contenedor.
    - Si las pruebas pasan -> Subir imagen a **Docker Hub**.
- **Seguridad (DevSecOps):**
  - Integrar **SonarCloud** (Análisis estático).
  - Integrar **Snyk** (Vulnerabilidades).
  - Integrar **GitHub Advanced Security** (Secretos y dependencias).
  - Integrar **Docker Scout** (Análisis de imagen).
  - **Regla de Oro:** El pipeline debe fallar si encuentra errores críticos.

### Etapa 1

Antes de escribir una sola línea de código del pipeline, necesitamos configurar las cuentas y secretos. Sin esto, el pipeline fallará inmediatamente.

#### 1\. Servicios involucrados necesarias

- **Docker Hub:** (<https://hub.docker.com/>) -> Se crea un repositorio público vacío llamado auy1102-g3 (o cualquier nombre que haga alusión).
- **Snyk:** (<https://snyk.io/>) -> Entrar con la cuenta GitHub.
- **SonarCloud**.

#### 2\. Configuración Secretos en GitHub

En el repositorio de GitHub -> **Settings** -> **Secrets and variables** -> **Actions** -> **New repository secret**.

Agrega estos secretos:

- DOCKER_USERNAME: Usuario de Docker Hub.
- DOCKER_PASSWORD: Contraseña de Docker Hub (o un Access Token).
- SONAR_TOKEN: El token ya creado de SonarCloud.
- SNYK_TOKEN: Ir a Snyk -> Account Settings -> API Token -> Copiar.

<img width="1178" height="459" alt="Imagen1" src="https://github.com/user-attachments/assets/4722943e-6568-4394-9b30-3fdda6456d15" />

Ahora que ya se tiene los 4 pilares de seguridad configurados:

- **Docker Hub** (para guardar la app).
- **SonarCloud** (para calidad de código).
- **Snyk** (para vulnerabilidades de dependencias).
- **GitHub Secrets** (para conectar todo).

**3\. Instalación de Dependencias**

<img width="589" height="331" alt="Imagen2" src="https://github.com/user-attachments/assets/bc331afc-76ae-44ee-a956-8fd02705e30e" />

**4\. Creación de la rama develop**

<img width="589" height="147" alt="Imagen3" src="https://github.com/user-attachments/assets/7faecbb6-d6df-4745-a52c-33fe1bcacf14" />

<img width="589" height="63" alt="Imagen4" src="https://github.com/user-attachments/assets/c1d72adf-26b2-4f30-b054-31974a85e5c5" />

Ahora se realiza la contenerización de toda la aplicación actual del repositorio. Se creará una 'imagen' que incluye el código y todo lo necesario para que funcione (librerías y configuración). Esto permitirá aislar la aplicación de la máquina local y prepararla para ser probada y distribuida automáticamente a través del pipeline de CI/CD.

### ¿Qué se está empaquetando exactamente?

Las carpetas src y package.json.

- **El código:** Tiene la lógica de negocio (como sum.js, index.ts, etc.).
- **Las dependencias:** El package.json dice qué librerías necesita este código para vivir.
- **Las pruebas:** Tienes los tests unitarios que verifican que el código funcione.

El Dockerfile valida la calidad del software antes de empaquetarlo. Mediante un proceso de dos etapas, el sistema primero ejecuta las pruebas unitarias y compila el código TypeScript; posteriormente, genera una imagen final de producción que es segura y ligera, ya que excluye los archivos fuente originales y las librerías de desarrollo.

**Resumen de la Implementación del pipeline**

Con esto se ha configurado un "guardián automático" para el código. Con este pipeline, cada vez que un desarrollador sube cambios, el sistema realiza automáticamente cuatro tareas críticas:

- **Revisa la seguridad** de las librerías con Snyk y GitHub Advanced Security.
- **Mide la calidad** del código escrito con SonarCloud.
- **Empaqueta la aplicación** en un contenedor Docker y ejecuta los tests unitarios dentro de él para confirmar que funciona correctamente.
- **Sube la imagen** a Docker Hub y la escanea con Docker Scout solo si todas las pruebas anteriores fueron exitosas.

Esta arquitectura cumple con la estrategia de **Shift-Left Security**, detectando fallos y vulnerabilidades en las etapas más tempranas del desarrollo, lo que reduce drásticamente el costo y tiempo de corrección.

<img width="1178" height="181" alt="Imagen30" src="https://github.com/user-attachments/assets/4602a2d3-4bd1-4e36-bc50-811f39798b3c" />
<img width="589" height="251" alt="Imagen" src="https://github.com/user-attachments/assets/0008f6dd-27aa-4a6d-bc17-9925e9d8e126" />
<img width="1178" height="205" alt="Imagen" src="https://github.com/user-attachments/assets/0caacaeb-2523-4022-9d0a-1739a4d8e72d" />

### 1\. Requisito: "Integrar el uso de Docker Scout"

Es el último paso del trabajo de Docker.

**Evidencia en el código:**

YAML

\- name: Docker Scout Analysis

uses: docker/scout-action@v1 # <--- Aquí llamamos a la herramienta

with:

command: quickview,cves

image: \${{ secrets.DOCKER_USERNAME }}/auy1102-g3-2:latest

### 2\. Requisito: "Interrumpir el despliegue si se detectan problemas críticos"

Esto es lo más importante. El pipeline está diseñado como una compuerta. Si la seguridad no pasa, el despliegue **se cancela automáticamente**.

Esto se logra de **tres formas** simultáneas en el código:

#### A. El "Muro" entre trabajos (La cláusula needs)

En el archivo YAML, separamos el proceso en dos trabajos: security-analysis y docker-build-push.

En la siguiente línea:

YAML

docker-build-push:

needs: security-analysis # <--- Candado

**¿Qué significa?** El trabajo de Docker (que es el que despliega/sube la imagen) **está obligado a esperar** a que el trabajo de Seguridad termine en VERDE. Si Snyk o SonarCloud encuentran algo grave, el primer trabajo falla (ROJO) y el segundo **ni siquiera arranca**.

#### B. El Freno de Docker Scout

De esta forma se configura Docker Scout para que no solo "informe", sino que **rompa** el proceso si ve peligro.

**La evidencia en el código:**

YAML

only-severities: critical,high # Solo nos importan los errores graves

exit-code: true # <--- Este es el interruptor

- exit-code: true: Significa "Si encuentra vulnerabilidades críticas (Critical/High), **devuelve un error y coloca el pipeline en ROJO**".

#### C. El Freno de Snyk

Lo mismo se realiza con Snyk al principio:

**La evidencia en el código:**

YAML

args: --severity-threshold=high # <--- INTERRUPTOR DE SNYK

- Esto le dice a Snyk: "Si encuentra vulnerabilidades de nivel ALTO, falla el pipeline inmediatamente".

<img width="589" height="299" alt="Imagen" src="https://github.com/user-attachments/assets/88abf5db-bcbe-4ee5-8f57-29575dfe6223" />

Se evidencia que el mecanismo de seguridad (Snyk) bloqueó exitosamente el despliegue al detectar la vulnerabilidad crítica 'Prototype Pollution' en las dependencias, cumpliendo con el criterio de interrupción por fallos de seguridad.

En archivo YAML, se escribe la regla clave en el segundo trabajo (docker-build-push):

YAML

needs: security-analysis

Esto le dice a GitHub: _"No arrancar el motor de Docker hasta que el guardia de seguridad (Snyk/Sonar) dé luz verde"_.

- **Seguridad (Snyk):** Encontró vulnerabilidades críticas -> **Falló (ROJO ❌)**.
- **Pipeline:** Detiene todo.
- **Docker:** Fue **OMITIDO (SKIPPED)**. No se descarga la imagen base, no se compiló el código y, lo más importante, **no se subió nada a Docker Hub**.

**Saneamiento de Dependencias y Build**

- **Problema:** El proyecto estaba bloqueado por vulnerabilidades críticas de seguridad en dependencias anidadas y errores de compilación (npm run build) en archivos de prueba.
- **Solución:**
  - **Seguridad:** Se implementó una estrategia de **sobrescritura anidada (nested overrides)** en package.json para forzar la actualización de librerías internas vulnerables que no se podían corregir automáticamente.
  - **Compilación:** Se ajustaron los scripts de calidad (src/quality) agregando export {} para cumplir con los estándares estrictos de TypeScript sin eliminar el código de prueba.
- **Resultado:** Se obtuvieron **0 vulnerabilidades** en la auditoría y se logró una **compilación exitosa**, habilitando el despliegue seguro en Docker y CI/CD.

<img width="1178" height="165" alt="Imagen" src="https://github.com/user-attachments/assets/2dbf865e-6d6e-480b-861b-935dc1f3791f" />

<img width="1178" height="136" alt="Imagen" src="https://github.com/user-attachments/assets/8a57d2d9-d345-4cf9-9d0b-26718f8bd058" />

<img width="589" height="196" alt="Imagen" src="https://github.com/user-attachments/assets/96b7c2b9-4e9d-46b9-84a0-c45456b9a6b8" />

Ahora se suben los cambios validados al repositorio

<img width="1178" height="459" alt="Imagen" src="https://github.com/user-attachments/assets/a1b0efb7-8571-4cd6-bfdf-d93cab70f7cf" />

<img width="589" height="163" alt="Imagen" src="https://github.com/user-attachments/assets/217f0a13-cec1-4e05-9151-36c632a8308f" />

Probando el pipeline

<img width="589" height="235" alt="Imagen" src="https://github.com/user-attachments/assets/221c29bc-d56b-4675-95b2-37a2f0569fa5" />

Evidencia de funcionamiento:

<img width="1178" height="544" alt="Imagen" src="https://github.com/user-attachments/assets/21e7ff29-e543-4980-bd3f-07b8d3c9782e" />

<img width="589" height="292" alt="Imagen" src="https://github.com/user-attachments/assets/44fa185a-3659-49c3-a142-d978c3dc9a95" />

Ahora vemos que sonar cloud está impidiendo terminar los jobs:

<img width="589" height="296" alt="Imagen" src="https://github.com/user-attachments/assets/0fbb1367-6bc7-4c3e-9fa8-878bc221787f" />

Se corrige los key que ocupa sonnar cloud:

<img width="589" height="147" alt="Imagen" src="https://github.com/user-attachments/assets/58397026-0b99-4eb2-8517-ee7f4d0850e2" />

Se logra pasar la barrera de Seguridad y Calidad (Snyk y SonarCloud están en verde ✅). Ahora se tiene problemas con las pruebas unitarias en del docker.

**Dockerfile** tiene una instrucción para ejecutar los tests unitarios antes de empaquetar la aplicación, y **esos tests están fallando**.

<img width="589" height="292" alt="Imagen" src="https://github.com/user-attachments/assets/8b0c6565-29e3-4f0d-b2a0-0fb1ee8707d6" />

Se revisa que se tenía un test con error:

**Se corrige la lógica del test isEmpty** asignando manualmente un texto vacío ('') en lugar de usar un generador aleatorio, para que el resultado coincida con lo esperado.

**Se valida exitosamente las pruebas en local (18/18 tests en verde)**, confirmando que el error que bloqueaba la construcción de Docker ha desaparecido.

<img width="1178" height="499" alt="Imagen" src="https://github.com/user-attachments/assets/e0df86cf-2f7e-4e14-90c5-00f7ef4bb419" />

<img width="1178" height="413" alt="Imagen" src="https://github.com/user-attachments/assets/153a5f0f-a764-4aa2-8e27-5b1b7efd69e6" />

Se realizan pruebas de forma local para validar que logren pasar cuando se suban los cambios al pipeline:

<img width="589" height="181" alt="Imagen" src="https://github.com/user-attachments/assets/9f85280f-8083-4625-bffc-58aa5a5c7b70" />

<img width="1178" height="293" alt="Imagen" src="https://github.com/user-attachments/assets/83bc3fad-7173-4b39-b5f7-dc03c5207cc1" />

<img width="589" height="239" alt="Imagen" src="https://github.com/user-attachments/assets/5e7fd377-c416-481f-b061-f2e384aeb5be" />

<img width="589" height="152" alt="Imagen" src="https://github.com/user-attachments/assets/9e182eb4-f175-4c19-9d74-29d148d7a2e4" />

**Se reordena el pipeline** para que Docker Scout escanee la imagen **antes** de subirla a Docker Hub, evitando publicar imágenes inseguras.

**Se actualiza el Dockerfile** a node:20-alpine3.20 con usuario no-root y **se arregla Jest** para que los tests funcionen en el contenedor.

- **ANÁLISIS DE CÓDIGO Y SEGURIDAD**

**Implementación de Seguridad y Análisis Estático (DevSecOps)**

Objetivo de la implementación: En cumplimiento con los requerimientos de la Parte 2, se ha diseñado un pipeline que no solo automatiza la integración, sino que actúa como una barrera de calidad y seguridad antes de cualquier despliegue. El objetivo es detectar vulnerabilidades, bugs y deudas técnicas en etapas tempranas (Shift-Left Testing).

**Herramientas integradas:**

**SonarCloud:** Integrado para realizar análisis estático de código (SAST) en cada pull request hacia la rama main. Se configuró para evaluar la mantenibilidad, fiabilidad y seguridad del código fuente. \* Snyk: Implementado para el escaneo de dependencias y código, asegurando que no se introduzcan librerías con vulnerabilidades conocidas (CVEs). \* GitHub Advanced Security: Se habilitaron las funciones de escaneo de secretos (para evitar fugas de credenciales) y análisis de dependencias mediante Dependency Review. \* Docker Scout: Incorporado para analizar la imagen del contenedor construida, buscando vulnerabilidades en el sistema base y las capas de la imagen.

**Política de Calidad:** El pipeline se ha configurado bajo una política de "tolerancia cero" a errores críticos. Si cualquiera de estas herramientas detecta una vulnerabilidad severa o no cumple con el Quality Gate definido, el pipeline fallará automáticamente, interrumpiendo el despliegue para garantizar la integridad del producto.

**SonarCloud:**

<img width="589" height="300" alt="Imagen" src="https://github.com/user-attachments/assets/17d1abfb-6ec2-4c16-9af9-44a9831088a0" />

<img width="589" height="316" alt="Imagen" src="https://github.com/user-attachments/assets/f4c4d9ad-161b-40c7-ba8f-f94079bfea97" />

Se corrige y actualiza las dependencias:

<img width="1178" height="104" alt="Imagen" src="https://github.com/user-attachments/assets/13028c25-6594-4d4e-b36f-988b997ff7d4" />

<img width="910" height="663" alt="Imagen" src="https://github.com/user-attachments/assets/1b8dea6b-f588-4188-b070-eb5d85be4a1a" />


## Using Github NPM Registry - Local Environment

### Authenticating to the NPM Registry

1. Setting your [access token](https://docs.github.com/en/packages/learn-github-packages/about-permissions-for-github-packages#about-scopes-and-permissions-for-package-registries), to enable GitHub functions like an OAuth access token and authenticates the access to the GitHub API.

    Select the ```read:packages``` scope to download container images and read their metadata.

    Select the ```write:packages``` scope to download and upload container images and read and write their metadata.

    Select the ```delete:packages``` scope to delete container images.

2. To authenticate by adding your personal access token to your ~/.npmrc file, edit the ~/.npmrc file for your project to include the following line, replacing TOKEN with your personal access token. Create a new ~/.npmrc file if one doesn't exist.

    ```
    //npm.pkg.github.com/:_authToken=TOKEN
    ```
3. To authenticate by logging in to npm, use the ```npm login``` command, replacing USERNAME with your GitHub username, TOKEN with your personal access token, and PUBLIC-EMAIL-ADDRESS with your email address.

If GitHub Packages is not your default package registry for using npm and you want to use the ```npm audit``` command, we recommend you use the ```--scope``` flag with the owner of the package when you authenticate to GitHub Packages.

```
  $ npm login --scope=@OWNER --registry=https://npm.pkg.github.com
  > Username: USERNAME
  > Password: TOKEN
  > Email: PUBLIC-EMAIL-ADDRESS
```

### Pushing packages

#### Publishing a package using a local .npmrc file

You can use an .npmrc file to configure the scope mapping for your project. In the .npmrc file, use the GitHub Packages URL and account owner so GitHub Packages knows where to route package requests. Using an .npmrc file prevents other developers from accidentally publishing the package to npmjs.org instead of GitHub Packages.

1. Authenticate to GitHub Packages. For more information, see "[Authenticating to GitHub Packages](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry#authenticating-to-github-packages)."
2. In the same directory as your ```package.json``` file, create or edit an ```.npmrc``` file to include a line specifying GitHub Packages URL and the account owner. Replace ```OWNER``` with the name of the user or organization account that owns the repository containing your project.

    ```
    @OWNER:registry=https://npm.pkg.github.com
    ```

3. Add the .npmrc file to the repository where GitHub Packages can find your project. For more information, see "[Adding a file to a repository](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository)."

    **NOTE**: Include on [```.gitignore```](https://docs.github.com/en/get-started/getting-started-with-git/ignoring-files) the exclusion of .npmrc to not compromise security.

4. Verify the name of your package in your project's package.json. The name field must contain the scope and the ```name``` of the package. For example, if your package is called "test", and you are publishing to the "My-org" GitHub organization, the ```name``` field in your package.json should be ```@my-org/test```.

5. Verify the repository field in your project's package.json. The ```repository``` field must match the URL for your GitHub ```repository```. For example, if your repository URL is ```github.com/my-org/test``` then the repository field should be ```https://github.com/my-org/test.git```.

6. Publish the package:

    ```
    $ npm publish
    ```

#### Publishing a package using publishConfig in the package.json file

You can use ```publishConfig``` element in the package.json file to specify the registry where you want the package published. For more information, see "[publishConfig](https://docs.npmjs.com/files/package.json#publishconfig)" in the npm documentation.

1. Edit the package.json file for your package and include a ```publishConfig``` entry.

```
"publishConfig": {
  "registry":"https://npm.pkg.github.com"
},
```

2. Verify the ```repository``` field in your project's package.json. The ```repository``` field must match the URL for your GitHub repository. For example, if your repository URL is ```github.com/my-org/test``` then the repository field should be ```https://github.com/my-org/test.git```

3. Publish the package:

      ```
      $ npm publish
      ```
To discover every way to working with [NPM Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry) please generete and **ISSUE**.

<br>

## Using Github Container Registry - Github Action
<br>

```
name: Create and publish NPM Package
on:
  release:
    types: [published]

jobs:
  Publish-NPM-Package:
    runs-on: ubuntu-latest
    permissions:
      packages: write
      contents: read
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
          cache-dependency-path: package-lock.json
          registry-url: https://npm.pkg.github.com
      - run: npm install
      - run: npm ci
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{secrets.PAT_GITHUB_TOKEN}}
```
```
name: NPM Audit
on:
  pull_request: 
    branches: [develop, staging, master]
    types: [opened, synchronize]

jobs:
  npm-audit:
    name: npm audit
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: install dependencies
        run: npm ci
      - uses: oke-py/npm-audit-action@v2
        with:
          audit_level: moderate
          github_token: ${{ secrets.PAT_GITHUB_TOKEN }}
          issue_assignees: oke-py
          issue_labels: vulnerability,test
          dedupe_issues: true
```

To enable more capabilities and demostrate the strongest of Github and Github Actions we complement this example with [Github Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows) using Open Source Tools and Enterprise Tools on Actions.

Reusing workflows avoids duplication. This makes workflows easier to maintain and allows you to create new workflows more quickly by building on the work of others, just as you do with actions. Workflow reuse also promotes best practice by helping you to use workflows that are well designed, have already been tested, and have been proved to be effective. Your organization can build up a library of reusable workflows that can be centrally maintained.

**Note:** To enable your actions, in some cases you must configurate [encrypted secrets](https://docs.github.com/en/enterprise-cloud@latest/actions/security-guides/encrypted-secrets)

<br>

```
name: Github Reusable Workflow
on:
  pull_request: 
    branches: [develop, staging, master]
    types: [opened, synchronize]
  release:
    types: [published]

jobs:
  NPM-Audit:
    if: github.event_name != 'opened'
    uses: ./.github/workflows/npm-audit.yml
    secrets:
      PAT_GITHUB_TOKEN: ${{ secrets.PAT_GITHUB_TOKEN }}
  
  NPM-Publish:
    if: ${{ (github.event.release.action == 'released') && always() }}
    uses: ./.github/workflows/npm-registry.yml
    needs: [NPM-Audit]
    secrets:
      PAT_GITHUB_TOKEN: ${{ secrets.PAT_GITHUB_TOKEN }}
```
<br>

## License

The scripts and documentation in this project are released under the [MIT License](./LICENSE)
## Contributions

Contributions are welcome! read our [Contributor's Guide](./docs/CONTRIBUTING.md)

## Code of Conduct

👋 Be nice. See our [code of conduct](./docs/code_of_conduct.md)

## References

+ **NPM Publish:** https://github.com/actions/setup-node
+ **NPM Audit Signatures:** https://github.blog/changelog/2022-07-26-a-new-npm-audit-signatures-command-to-verify-npm-package-integrity/
+ **NPM Audit:** https://github.com/marketplace/actions/npm-audit-action
