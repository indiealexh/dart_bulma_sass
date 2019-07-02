import 'dart:io';
import 'dart:async';
import 'package:git/git.dart';
import 'package:pub_semver/pub_semver.dart';

///
/// This tool requires Docker and Git to be installed locally.
///

main() async {
  Directory workingDir = await Directory.systemTemp.createTemp();
  Directory currentDir = Directory.current;

  print("Work $workingDir");
  print("Current $currentDir");

  GitDir gitDir = await setupGit(workingDir);
  List<Version> tags = await getVersions(gitDir);
  await checkoutVersionTag(gitDir, tags.last);
  print("Running conversion");
  await Process.run('docker', [
    "run",
    '-v' + pathToUnixPath(workingDir.path) + '/sass:/workdir',
    "-w/workdir",
    "unibeautify/sass-convert",
    "-Fsass",
    "-Tscss",
    "-R",
    "/workdir"
  ], environment: {
    "COMPOSE_CONVERT_WINDOWS_PATHS": "1"
  });
  print("Conversion complete");

  Directory workingSassDir = new Directory(workingDir.path + "\\sass");
  await fsCleanUpOps(workingSassDir);
  await tidyScssContents(workingSassDir);
  await copyWorkingToCurrent(workingDir, currentDir);

  print("Cleaning up");
  await workingDir.delete(recursive: true);
  print("Finished");
}

Future copyWorkingToCurrent(Directory workingDir, Directory currentDir) async {
  Directory oldScssDir = new Directory(workingDir.path + "\\sass");
  Directory newScssDir = new Directory(currentDir.path + "\\lib\\scss");

  List<FileSystemEntity> fileEntities = oldScssDir.listSync(recursive: true);
  List<File> files = new List<File>();
  fileEntities.forEach((FileSystemEntity fileSystemEntity) {
    if (fileSystemEntity.statSync().type == FileSystemEntityType.FILE) {
      files.add(new File(fileSystemEntity.path));
    }
  });
  List<Future> fsOps = new List<Future>();
  print("Copying files");
  files.forEach((File file) {
    String newPath = file.path.replaceFirst(oldScssDir.path, newScssDir.path);
    fsOps.add(file.copy(newPath));
  });
  await Future.wait(fsOps);
}

Future tidyScssContents(Directory workingSassDir) async {
  List<FileSystemEntity> files = workingSassDir.listSync(recursive: true);
  List<Future> fileOperations = new List<Future>();
  print("Running scss file clean up operations");
  files.forEach((FileSystemEntity f) {
    if (f.path.contains(".scss")) {
      Completer completer = new Completer();
      File file = new File(f.path);
      file.readAsString().then((String content) {
        content = content.replaceAll("\.sass", "");
        file.writeAsString(content).then((_) {
          completer.complete();
        });
      });
      fileOperations.add(completer.future);
    }
  });
  print("Waiting on file operations");
  await Future.wait(fileOperations);
}

Future fsCleanUpOps(Directory workingSassDir) async {
  List<FileSystemEntity> files = workingSassDir.listSync(recursive: true);
  List<Future> fileOperations = new List<Future>();
  print("Running file system clean up operations");
  files.forEach((FileSystemEntity f) {
    if (f.path.contains(".scss")) {
      List<String> oldPathParts = f.path.split("\\");
      if (!oldPathParts.last.contains("_")) {
        oldPathParts.last = "_" + oldPathParts.last;
        String newPath = oldPathParts.join("\\");
        fileOperations.add(f.rename(newPath));
      }
    } else {
      if (f.statSync().type == FileSystemEntityType.FILE) {
        fileOperations.add(f.delete());
      }
    }
  });
  print("Waiting on file operations");
  await Future.wait(fileOperations);
}

String pathToUnixPath(String path) {
  List<String> parts = path.split('\\');
  parts.first = parts.first.replaceAll(':', '');
  String output = "//" + parts.join("/");
  return output;
}

Future<GitDir> setupGit(Directory dir,
    [String gitRemote = 'https://github.com/jgthms/bulma.git']) async {
  GitDir gitDir = await GitDir.init(dir.uri.toFilePath());
  await gitDir.runCommand(['remote', 'add', 'origin', gitRemote]);
  await gitDir.runCommand(['fetch', '--all']);
  return gitDir;
}

Future<List<Version>> getVersions(GitDir gitDir) async {
  ProcessResult tagList = await gitDir.runCommand(['tag', '--list']);
  List<String> strings = tagList.stdout.toString().trim().split("\n");
  List<Version> versions = new List<Version>();
  for (String versionString in strings) {
    versions.add(new Version.parse(versionString));
  }
  versions.sort((a, b) => Version.prioritize(a, b));
  return versions;
}

Future checkoutVersionTag(GitDir gitDir, Version tag) async {
  print("Checking out $tag");
  await gitDir.runCommand(['checkout', "tags/$tag"]);
}
