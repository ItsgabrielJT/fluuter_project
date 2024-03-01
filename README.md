<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://esfot.epn.edu.ec/images/headers/logo_esfot_buho.png" alt="Esfot" width="300px"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

# Proyecto final de Aplicaciones moviles

El presente proyecto tiene como objetivo evaluar el desarrollo de aplicaciones móviles híbridas nativas con servicios en segundo plano.
Se necesita una solución que me permita trackear en tiempo real la ubicación de tres dispositivos
para mapear terrenos. Una vez que se vaya mapeando los terrenos se debe calcular el área de 
dicho terreno.


## Autores 🪬

- [@Joel Tates](https://github.com/ItsgabrielJT)
- [@Salomé Quispe](https://github.com/Salo-Quispe)
- [@Jose Galarza](https://github.com/jp123468)
- [@Dany Vinueza](https://github.com/DannyVinueza)
- [@Daniel Quishpe](https://github.com/DAQG)
- [@Nestor Chumania](https://github.com/RotsenCH)


## Stack Tecnico 🧩👥

**Sistema Web** codigo del portal del [administrador web](https://github.com/DannyVinueza/Web_Flutter_Pagina)

**Librerias:** Flutter, Google Maps Plataform.

**Firebase:** Authentication, Cloud Firestore, Storage.

## Modulos y funcionalidades 🧩👥

- Login y registro
- Geolocalizacion en tiempo real
- Calculo de areas
- Sistema de administracion web de usuarios

## Instalacion local del proyecto ⚠️⚠️⚠️⚠️


Clonar el proyecto

```bash
  git clone https://github.com/ItsgabrielJT/flutter-geolocate-areas
```

Ir al directorio del proyecto

```bash
  cd flutter-geolocate-areas
```

Instalar las dependecias de flutter

```bash
  flutter pub get
```

Para crear el archivo de credenciales
**(recordemos el tener instalado flutterfire antes)**
```bash
  flutterfire configure
```


> En caso de haber ocurrido un error con las dependecias del proyecto ejecutar lo siguiente ⚠️


```bash
  flutter pub outdated
  flutter pub upgrade
```
## Documentacion tecnica 📁

#### Configuracion para la geolocalizacion en tiempo real
Primero tenemos que generar la api de google desde la plataforma de [google cloud](https://console.cloud.google.com/welcome) tal como estamos viendo en la imagen
[![imagen-2024-02-29-102617547.png](https://i.postimg.cc/m2cwfCb2/imagen-2024-02-29-102617547.png)](https://postimg.cc/Vd8MXSr3)

Una vez hecho eso, tenemos que tener habilitados los servicios de maps sdk android, geolocation api y map spi javascript este ultimo lo usaremos para la version del sistema web que pueden acceder desde el repositorio de arriba

[![imagen-2024-02-29-102915652.png](https://i.postimg.cc/Pf1DmyrD/imagen-2024-02-29-102915652.png)](https://postimg.cc/7bYb4gzP)

Tambien tenemos qye pegar la api que habiamos generado previamente en el archivo encontrado en la ruta **android/app/src/main/AndroidManifest.xml**

```xml
  <manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

tambien tenemos que cambiar el minSdk eso lo hacemos en el archivo ubicado en la ruta **android/app/build.gradle** (Recordemos actulizar los cambios de gradle)

```gradle
  android {
    defaultConfig {
        minSdkVersion 26
    }
}
```

Con todo esto tendremos terminado la configuracion para la geolocalizacion con google map 🏅

## Videos Explicativos 📁

A continuación proporcionamos un link para poder visualizar 
- [Link videos](https://epnecuador-my.sharepoint.com/:f:/g/personal/nestor_chumania_epn_edu_ec/EmG-2gYtNhdFn8CLep4M-FsB_WBHeIlSQsgssAey7XlVqA?e=GkTn3Z)

#### Configuracion de permisos de ubicacion y ejecucion en segundo plano

Como ya sabemos si nosotros no especificamos los permisos desde el **android/app/src/main/AndroidManifest.xml** aunque nuestro codigo este compilandose bien no funcionara para ello tenemos que agregar los permisos siguientes

```xml
  <manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
  <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
    <application ...
```


## Tienda de aplicaciones y despliegue web 🚀🧩
- La apk fue publicada en la **Google Play Store**.

- [Link apk](https://project-core-front.vercel.app)

<br>

- El sistema web **administrador**.

- [Link deploy](https://geolocation-flutter-app.web.app/)

## Licencia

This project is under the [MIT license](https://opensource.org/licenses/MIT).




