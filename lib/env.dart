class Def {
  static const String version = "vsn";
}

class Env {
  static const version = String.fromEnvironment(Def.version);
}
