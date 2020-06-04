class ModelConfig
{
  String name;
  String description;
  List<String> versions;
  DateTime lastChange;
  int size;

  ModelConfig.fromJson(Map<String, dynamic> json)
    : name = json["name"] as String,
      versions = List<String>.from(json["versions"] as List<dynamic>),
      lastChange = DateTime.parse(json["lastChange"] as String),
      description = json["description"] as String,
      size = json["size"] as int;
  
  Map<String, dynamic> toJson() =>
    {
      "name": name,
      "versions": versions,
      "lastChange": lastChange,
      "description": description,
      "size": size
    };
}

Map<String, ModelConfig> toMapByName(List<ModelConfig> configs)
{
  Map<String, ModelConfig> mapByName = Map<String, ModelConfig>();
  for(final config in configs)
  {
    mapByName[config.name] = config;
  }
  return mapByName;
}
