// based on https://medium.com/preply-engineering/jenkins-omg-275e2df5d647
// run in jenkins script console

Jenkins.instance.pluginManager.plugins.each{
  plugin ->
    println ("${plugin.getShortName()}:${plugin.getVersion()}")
}

// copy plugins that are displayed in the list- that is, all text from the top, up to the “Result:” section and create a file plugins.txt and paste the copied text there.

// Not all off this plugins are required when using jenkinsci/blueocean docker image,
// already installed plugins or dependencies will be skipped during building own docker image.
