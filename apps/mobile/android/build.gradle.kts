allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Flutter's plugins inherit the SDK configured by the Flutter Gradle plugin.
// Keep library plugins on the same Android API level as the application so
// androidx lifecycle metadata checks can resolve.
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
        extensions.findByName("android")?.let { androidExtension ->
            androidExtension.javaClass
                .methods
                .firstOrNull { it.name == "setCompileSdk" && it.parameterCount == 1 }
                ?.invoke(androidExtension, 36)
        }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
