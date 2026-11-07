// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'docker.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageHistoryResponseItem _$ImageHistoryResponseItemFromJson(
  Map<String, dynamic> json,
) => ImageHistoryResponseItem(
  id: json['Id'] as String,
  created: (json['Created'] as num).toInt(),
  createdBy: json['CreatedBy'] as String,
  tags:
      (json['Tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  size: (json['Size'] as num).toInt(),
  comment: json['Comment'] as String,
);

Map<String, dynamic> _$ImageHistoryResponseItemToJson(
  ImageHistoryResponseItem instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Created': instance.created,
  'CreatedBy': instance.createdBy,
  'Tags': instance.tags,
  'Size': instance.size,
  'Comment': instance.comment,
};

PortSummary _$PortSummaryFromJson(Map<String, dynamic> json) => PortSummary(
  ip: json['IP'] as String?,
  privatePort: (json['PrivatePort'] as num).toInt(),
  publicPort: (json['PublicPort'] as num?)?.toInt(),
  type: portSummaryTypeFromJson(json['Type']),
);

Map<String, dynamic> _$PortSummaryToJson(PortSummary instance) =>
    <String, dynamic>{
      'IP': instance.ip,
      'PrivatePort': instance.privatePort,
      'PublicPort': instance.publicPort,
      'Type': portSummaryTypeToJson(instance.type),
    };

MountPoint _$MountPointFromJson(Map<String, dynamic> json) => MountPoint(
  type: mountTypeNullableFromJson(json['Type']),
  name: json['Name'] as String?,
  source: json['Source'] as String?,
  destination: json['Destination'] as String?,
  driver: json['Driver'] as String?,
  mode: json['Mode'] as String?,
  rw: json['RW'] as bool?,
  propagation: json['Propagation'] as String?,
);

Map<String, dynamic> _$MountPointToJson(MountPoint instance) =>
    <String, dynamic>{
      'Type': mountTypeNullableToJson(instance.type),
      'Name': instance.name,
      'Source': instance.source,
      'Destination': instance.destination,
      'Driver': instance.driver,
      'Mode': instance.mode,
      'RW': instance.rw,
      'Propagation': instance.propagation,
    };

DeviceMapping _$DeviceMappingFromJson(Map<String, dynamic> json) =>
    DeviceMapping(
      pathOnHost: json['PathOnHost'] as String?,
      pathInContainer: json['PathInContainer'] as String?,
      cgroupPermissions: json['CgroupPermissions'] as String?,
    );

Map<String, dynamic> _$DeviceMappingToJson(DeviceMapping instance) =>
    <String, dynamic>{
      'PathOnHost': instance.pathOnHost,
      'PathInContainer': instance.pathInContainer,
      'CgroupPermissions': instance.cgroupPermissions,
    };

DeviceRequest _$DeviceRequestFromJson(
  Map<String, dynamic> json,
) => DeviceRequest(
  driver: json['Driver'] as String?,
  count: (json['Count'] as num?)?.toInt(),
  deviceIDs:
      (json['DeviceIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  capabilities:
      (json['Capabilities'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
          .toList() ??
      [],
  options: json['Options'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$DeviceRequestToJson(DeviceRequest instance) =>
    <String, dynamic>{
      'Driver': instance.driver,
      'Count': instance.count,
      'DeviceIDs': instance.deviceIDs,
      'Capabilities': instance.capabilities,
      'Options': instance.options,
    };

ThrottleDevice _$ThrottleDeviceFromJson(Map<String, dynamic> json) =>
    ThrottleDevice(
      path: json['Path'] as String?,
      rate: (json['Rate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ThrottleDeviceToJson(ThrottleDevice instance) =>
    <String, dynamic>{'Path': instance.path, 'Rate': instance.rate};

Mount _$MountFromJson(Map<String, dynamic> json) => Mount(
  target: json['Target'] as String?,
  source: json['Source'] as String?,
  type: mountTypeNullableFromJson(json['Type']),
  readOnly: json['ReadOnly'] as bool?,
  consistency: json['Consistency'] as String?,
  bindOptions: json['BindOptions'] == null
      ? null
      : Mount$BindOptions.fromJson(json['BindOptions'] as Map<String, dynamic>),
  volumeOptions: json['VolumeOptions'] == null
      ? null
      : Mount$VolumeOptions.fromJson(
          json['VolumeOptions'] as Map<String, dynamic>,
        ),
  imageOptions: json['ImageOptions'] == null
      ? null
      : Mount$ImageOptions.fromJson(
          json['ImageOptions'] as Map<String, dynamic>,
        ),
  tmpfsOptions: json['TmpfsOptions'] == null
      ? null
      : Mount$TmpfsOptions.fromJson(
          json['TmpfsOptions'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MountToJson(Mount instance) => <String, dynamic>{
  'Target': instance.target,
  'Source': instance.source,
  'Type': mountTypeNullableToJson(instance.type),
  'ReadOnly': instance.readOnly,
  'Consistency': instance.consistency,
  'BindOptions': instance.bindOptions?.toJson(),
  'VolumeOptions': instance.volumeOptions?.toJson(),
  'ImageOptions': instance.imageOptions?.toJson(),
  'TmpfsOptions': instance.tmpfsOptions?.toJson(),
};

RestartPolicy _$RestartPolicyFromJson(Map<String, dynamic> json) =>
    RestartPolicy(
      name: restartPolicyNameNullableFromJson(json['Name']),
      maximumRetryCount: (json['MaximumRetryCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RestartPolicyToJson(RestartPolicy instance) =>
    <String, dynamic>{
      'Name': restartPolicyNameNullableToJson(instance.name),
      'MaximumRetryCount': instance.maximumRetryCount,
    };

Resources _$ResourcesFromJson(Map<String, dynamic> json) => Resources(
  cpuShares: (json['CpuShares'] as num?)?.toInt(),
  memory: (json['Memory'] as num?)?.toInt(),
  cgroupParent: json['CgroupParent'] as String?,
  blkioWeight: (json['BlkioWeight'] as num?)?.toInt(),
  blkioWeightDevice: (json['BlkioWeightDevice'] as List<dynamic>?)
      ?.map(
        (e) => Resources$BlkioWeightDevice$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  blkioDeviceReadBps:
      (json['BlkioDeviceReadBps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  blkioDeviceWriteBps:
      (json['BlkioDeviceWriteBps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  blkioDeviceReadIOps:
      (json['BlkioDeviceReadIOps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  blkioDeviceWriteIOps:
      (json['BlkioDeviceWriteIOps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  cpuPeriod: (json['CpuPeriod'] as num?)?.toInt(),
  cpuQuota: (json['CpuQuota'] as num?)?.toInt(),
  cpuRealtimePeriod: (json['CpuRealtimePeriod'] as num?)?.toInt(),
  cpuRealtimeRuntime: (json['CpuRealtimeRuntime'] as num?)?.toInt(),
  cpusetCpus: json['CpusetCpus'] as String?,
  cpusetMems: json['CpusetMems'] as String?,
  devices:
      (json['Devices'] as List<dynamic>?)
          ?.map((e) => DeviceMapping.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  deviceCgroupRules:
      (json['DeviceCgroupRules'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  deviceRequests:
      (json['DeviceRequests'] as List<dynamic>?)
          ?.map((e) => DeviceRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  memoryReservation: (json['MemoryReservation'] as num?)?.toInt(),
  memorySwap: (json['MemorySwap'] as num?)?.toInt(),
  memorySwappiness: (json['MemorySwappiness'] as num?)?.toInt(),
  nanoCpus: (json['NanoCpus'] as num?)?.toInt(),
  oomKillDisable: json['OomKillDisable'] as bool?,
  init: json['Init'] as bool?,
  pidsLimit: (json['PidsLimit'] as num?)?.toInt(),
  ulimits: (json['Ulimits'] as List<dynamic>?)
      ?.map((e) => Resources$Ulimits$Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  cpuCount: (json['CpuCount'] as num?)?.toInt(),
  cpuPercent: (json['CpuPercent'] as num?)?.toInt(),
  iOMaximumIOps: (json['IOMaximumIOps'] as num?)?.toInt(),
  iOMaximumBandwidth: (json['IOMaximumBandwidth'] as num?)?.toInt(),
);

Map<String, dynamic> _$ResourcesToJson(Resources instance) => <String, dynamic>{
  'CpuShares': instance.cpuShares,
  'Memory': instance.memory,
  'CgroupParent': instance.cgroupParent,
  'BlkioWeight': instance.blkioWeight,
  'BlkioWeightDevice': instance.blkioWeightDevice
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceReadBps': instance.blkioDeviceReadBps
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceWriteBps': instance.blkioDeviceWriteBps
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceReadIOps': instance.blkioDeviceReadIOps
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceWriteIOps': instance.blkioDeviceWriteIOps
      ?.map((e) => e.toJson())
      .toList(),
  'CpuPeriod': instance.cpuPeriod,
  'CpuQuota': instance.cpuQuota,
  'CpuRealtimePeriod': instance.cpuRealtimePeriod,
  'CpuRealtimeRuntime': instance.cpuRealtimeRuntime,
  'CpusetCpus': instance.cpusetCpus,
  'CpusetMems': instance.cpusetMems,
  'Devices': instance.devices?.map((e) => e.toJson()).toList(),
  'DeviceCgroupRules': instance.deviceCgroupRules,
  'DeviceRequests': instance.deviceRequests?.map((e) => e.toJson()).toList(),
  'MemoryReservation': instance.memoryReservation,
  'MemorySwap': instance.memorySwap,
  'MemorySwappiness': instance.memorySwappiness,
  'NanoCpus': instance.nanoCpus,
  'OomKillDisable': instance.oomKillDisable,
  'Init': instance.init,
  'PidsLimit': instance.pidsLimit,
  'Ulimits': instance.ulimits?.map((e) => e.toJson()).toList(),
  'CpuCount': instance.cpuCount,
  'CpuPercent': instance.cpuPercent,
  'IOMaximumIOps': instance.iOMaximumIOps,
  'IOMaximumBandwidth': instance.iOMaximumBandwidth,
};

Limit _$LimitFromJson(Map<String, dynamic> json) => Limit(
  nanoCPUs: (json['NanoCPUs'] as num?)?.toInt(),
  memoryBytes: (json['MemoryBytes'] as num?)?.toInt(),
  pids: (json['Pids'] as num?)?.toInt(),
);

Map<String, dynamic> _$LimitToJson(Limit instance) => <String, dynamic>{
  'NanoCPUs': instance.nanoCPUs,
  'MemoryBytes': instance.memoryBytes,
  'Pids': instance.pids,
};

ResourceObject _$ResourceObjectFromJson(Map<String, dynamic> json) =>
    ResourceObject(
      nanoCPUs: (json['NanoCPUs'] as num?)?.toInt(),
      memoryBytes: (json['MemoryBytes'] as num?)?.toInt(),
      genericResources: (json['GenericResources'] as List<dynamic>?)
          ?.map(
            (e) => GenericResources$Item.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ResourceObjectToJson(ResourceObject instance) =>
    <String, dynamic>{
      'NanoCPUs': instance.nanoCPUs,
      'MemoryBytes': instance.memoryBytes,
      'GenericResources': instance.genericResources
          ?.map((e) => e.toJson())
          .toList(),
    };

GenericResources$Item _$GenericResources$ItemFromJson(
  Map<String, dynamic> json,
) => GenericResources$Item(
  namedResourceSpec: json['NamedResourceSpec'] == null
      ? null
      : GenericResources$Item$NamedResourceSpec.fromJson(
          json['NamedResourceSpec'] as Map<String, dynamic>,
        ),
  discreteResourceSpec: json['DiscreteResourceSpec'] == null
      ? null
      : GenericResources$Item$DiscreteResourceSpec.fromJson(
          json['DiscreteResourceSpec'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GenericResources$ItemToJson(
  GenericResources$Item instance,
) => <String, dynamic>{
  'NamedResourceSpec': instance.namedResourceSpec?.toJson(),
  'DiscreteResourceSpec': instance.discreteResourceSpec?.toJson(),
};

HealthConfig _$HealthConfigFromJson(Map<String, dynamic> json) => HealthConfig(
  test:
      (json['Test'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  interval: (json['Interval'] as num?)?.toInt(),
  timeout: (json['Timeout'] as num?)?.toInt(),
  retries: (json['Retries'] as num?)?.toInt(),
  startPeriod: (json['StartPeriod'] as num?)?.toInt(),
  startInterval: (json['StartInterval'] as num?)?.toInt(),
);

Map<String, dynamic> _$HealthConfigToJson(HealthConfig instance) =>
    <String, dynamic>{
      'Test': instance.test,
      'Interval': instance.interval,
      'Timeout': instance.timeout,
      'Retries': instance.retries,
      'StartPeriod': instance.startPeriod,
      'StartInterval': instance.startInterval,
    };

Health _$HealthFromJson(Map<String, dynamic> json) => Health(
  status: healthStatusNullableFromJson(json['Status']),
  failingStreak: (json['FailingStreak'] as num?)?.toInt(),
  log:
      (json['Log'] as List<dynamic>?)
          ?.map((e) => HealthcheckResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$HealthToJson(Health instance) => <String, dynamic>{
  'Status': healthStatusNullableToJson(instance.status),
  'FailingStreak': instance.failingStreak,
  'Log': instance.log?.map((e) => e.toJson()).toList(),
};

HealthcheckResult _$HealthcheckResultFromJson(Map<String, dynamic> json) =>
    HealthcheckResult(
      start: json['Start'] == null
          ? null
          : DateTime.parse(json['Start'] as String),
      end: json['End'] as String?,
      exitCode: (json['ExitCode'] as num?)?.toInt(),
      output: json['Output'] as String?,
    );

Map<String, dynamic> _$HealthcheckResultToJson(HealthcheckResult instance) =>
    <String, dynamic>{
      'Start': instance.start?.toIso8601String(),
      'End': instance.end,
      'ExitCode': instance.exitCode,
      'Output': instance.output,
    };

HostConfig _$HostConfigFromJson(Map<String, dynamic> json) => HostConfig(
  binds:
      (json['Binds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  containerIDFile: json['ContainerIDFile'] as String?,
  logConfig: json['LogConfig'] == null
      ? null
      : HostConfig$LogConfig.fromJson(
          json['LogConfig'] as Map<String, dynamic>,
        ),
  networkMode: json['NetworkMode'] as String?,
  portBindings: json['PortBindings'] == null
      ? null
      : PortMap.fromJson(json['PortBindings'] as Map<String, dynamic>),
  restartPolicy: json['RestartPolicy'] == null
      ? null
      : RestartPolicy.fromJson(json['RestartPolicy'] as Map<String, dynamic>),
  autoRemove: json['AutoRemove'] as bool?,
  volumeDriver: json['VolumeDriver'] as String?,
  volumesFrom:
      (json['VolumesFrom'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  mounts:
      (json['Mounts'] as List<dynamic>?)
          ?.map((e) => Mount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  consoleSize:
      (json['ConsoleSize'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  annotations: json['Annotations'] as Map<String, dynamic>?,
  capAdd:
      (json['CapAdd'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  capDrop:
      (json['CapDrop'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  cgroupnsMode: hostConfigCgroupnsModeNullableFromJson(json['CgroupnsMode']),
  dns: (json['Dns'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  dnsOptions:
      (json['DnsOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  dnsSearch:
      (json['DnsSearch'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  extraHosts:
      (json['ExtraHosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  groupAdd:
      (json['GroupAdd'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  ipcMode: json['IpcMode'] as String?,
  cgroup: json['Cgroup'] as String?,
  links:
      (json['Links'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  oomScoreAdj: (json['OomScoreAdj'] as num?)?.toInt(),
  pidMode: json['PidMode'] as String?,
  privileged: json['Privileged'] as bool?,
  publishAllPorts: json['PublishAllPorts'] as bool?,
  readonlyRootfs: json['ReadonlyRootfs'] as bool?,
  securityOpt:
      (json['SecurityOpt'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  storageOpt: json['StorageOpt'] as Map<String, dynamic>?,
  tmpfs: json['Tmpfs'] as Map<String, dynamic>?,
  uTSMode: json['UTSMode'] as String?,
  usernsMode: json['UsernsMode'] as String?,
  shmSize: (json['ShmSize'] as num?)?.toInt(),
  sysctls: json['Sysctls'] as Map<String, dynamic>?,
  runtime: json['Runtime'] as String?,
  isolation: hostConfigIsolationNullableFromJson(json['Isolation']),
  maskedPaths:
      (json['MaskedPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  readonlyPaths:
      (json['ReadonlyPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  cpuShares: (json['CpuShares'] as num?)?.toInt(),
  memory: (json['Memory'] as num?)?.toInt(),
  cgroupParent: json['CgroupParent'] as String?,
  blkioWeight: (json['BlkioWeight'] as num?)?.toInt(),
  blkioWeightDevice: (json['BlkioWeightDevice'] as List<dynamic>?)
      ?.map(
        (e) => HostConfig$BlkioWeightDevice$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  blkioDeviceReadBps:
      (json['BlkioDeviceReadBps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  blkioDeviceWriteBps:
      (json['BlkioDeviceWriteBps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  blkioDeviceReadIOps:
      (json['BlkioDeviceReadIOps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  blkioDeviceWriteIOps:
      (json['BlkioDeviceWriteIOps'] as List<dynamic>?)
          ?.map((e) => ThrottleDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  cpuPeriod: (json['CpuPeriod'] as num?)?.toInt(),
  cpuQuota: (json['CpuQuota'] as num?)?.toInt(),
  cpuRealtimePeriod: (json['CpuRealtimePeriod'] as num?)?.toInt(),
  cpuRealtimeRuntime: (json['CpuRealtimeRuntime'] as num?)?.toInt(),
  cpusetCpus: json['CpusetCpus'] as String?,
  cpusetMems: json['CpusetMems'] as String?,
  devices:
      (json['Devices'] as List<dynamic>?)
          ?.map((e) => DeviceMapping.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  deviceCgroupRules:
      (json['DeviceCgroupRules'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  deviceRequests:
      (json['DeviceRequests'] as List<dynamic>?)
          ?.map((e) => DeviceRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  memoryReservation: (json['MemoryReservation'] as num?)?.toInt(),
  memorySwap: (json['MemorySwap'] as num?)?.toInt(),
  memorySwappiness: (json['MemorySwappiness'] as num?)?.toInt(),
  nanoCpus: (json['NanoCpus'] as num?)?.toInt(),
  oomKillDisable: json['OomKillDisable'] as bool?,
  init: json['Init'] as bool?,
  pidsLimit: (json['PidsLimit'] as num?)?.toInt(),
  ulimits: (json['Ulimits'] as List<dynamic>?)
      ?.map((e) => HostConfig$Ulimits$Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  cpuCount: (json['CpuCount'] as num?)?.toInt(),
  cpuPercent: (json['CpuPercent'] as num?)?.toInt(),
  iOMaximumIOps: (json['IOMaximumIOps'] as num?)?.toInt(),
  iOMaximumBandwidth: (json['IOMaximumBandwidth'] as num?)?.toInt(),
);

Map<String, dynamic> _$HostConfigToJson(
  HostConfig instance,
) => <String, dynamic>{
  'Binds': instance.binds,
  'ContainerIDFile': instance.containerIDFile,
  'LogConfig': instance.logConfig?.toJson(),
  'NetworkMode': instance.networkMode,
  'PortBindings': instance.portBindings?.toJson(),
  'RestartPolicy': instance.restartPolicy?.toJson(),
  'AutoRemove': instance.autoRemove,
  'VolumeDriver': instance.volumeDriver,
  'VolumesFrom': instance.volumesFrom,
  'Mounts': instance.mounts?.map((e) => e.toJson()).toList(),
  'ConsoleSize': instance.consoleSize,
  'Annotations': instance.annotations,
  'CapAdd': instance.capAdd,
  'CapDrop': instance.capDrop,
  'CgroupnsMode': hostConfigCgroupnsModeNullableToJson(instance.cgroupnsMode),
  'Dns': instance.dns,
  'DnsOptions': instance.dnsOptions,
  'DnsSearch': instance.dnsSearch,
  'ExtraHosts': instance.extraHosts,
  'GroupAdd': instance.groupAdd,
  'IpcMode': instance.ipcMode,
  'Cgroup': instance.cgroup,
  'Links': instance.links,
  'OomScoreAdj': instance.oomScoreAdj,
  'PidMode': instance.pidMode,
  'Privileged': instance.privileged,
  'PublishAllPorts': instance.publishAllPorts,
  'ReadonlyRootfs': instance.readonlyRootfs,
  'SecurityOpt': instance.securityOpt,
  'StorageOpt': instance.storageOpt,
  'Tmpfs': instance.tmpfs,
  'UTSMode': instance.uTSMode,
  'UsernsMode': instance.usernsMode,
  'ShmSize': instance.shmSize,
  'Sysctls': instance.sysctls,
  'Runtime': instance.runtime,
  'Isolation': hostConfigIsolationNullableToJson(instance.isolation),
  'MaskedPaths': instance.maskedPaths,
  'ReadonlyPaths': instance.readonlyPaths,
  'CpuShares': instance.cpuShares,
  'Memory': instance.memory,
  'CgroupParent': instance.cgroupParent,
  'BlkioWeight': instance.blkioWeight,
  'BlkioWeightDevice': instance.blkioWeightDevice
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceReadBps': instance.blkioDeviceReadBps
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceWriteBps': instance.blkioDeviceWriteBps
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceReadIOps': instance.blkioDeviceReadIOps
      ?.map((e) => e.toJson())
      .toList(),
  'BlkioDeviceWriteIOps': instance.blkioDeviceWriteIOps
      ?.map((e) => e.toJson())
      .toList(),
  'CpuPeriod': instance.cpuPeriod,
  'CpuQuota': instance.cpuQuota,
  'CpuRealtimePeriod': instance.cpuRealtimePeriod,
  'CpuRealtimeRuntime': instance.cpuRealtimeRuntime,
  'CpusetCpus': instance.cpusetCpus,
  'CpusetMems': instance.cpusetMems,
  'Devices': instance.devices?.map((e) => e.toJson()).toList(),
  'DeviceCgroupRules': instance.deviceCgroupRules,
  'DeviceRequests': instance.deviceRequests?.map((e) => e.toJson()).toList(),
  'MemoryReservation': instance.memoryReservation,
  'MemorySwap': instance.memorySwap,
  'MemorySwappiness': instance.memorySwappiness,
  'NanoCpus': instance.nanoCpus,
  'OomKillDisable': instance.oomKillDisable,
  'Init': instance.init,
  'PidsLimit': instance.pidsLimit,
  'Ulimits': instance.ulimits?.map((e) => e.toJson()).toList(),
  'CpuCount': instance.cpuCount,
  'CpuPercent': instance.cpuPercent,
  'IOMaximumIOps': instance.iOMaximumIOps,
  'IOMaximumBandwidth': instance.iOMaximumBandwidth,
};

ContainerConfig _$ContainerConfigFromJson(
  Map<String, dynamic> json,
) => ContainerConfig(
  hostname: json['Hostname'] as String?,
  domainname: json['Domainname'] as String?,
  user: json['User'] as String?,
  attachStdin: json['AttachStdin'] as bool? ?? false,
  attachStdout: json['AttachStdout'] as bool? ?? true,
  attachStderr: json['AttachStderr'] as bool? ?? true,
  exposedPorts: json['ExposedPorts'] as Map<String, dynamic>?,
  tty: json['Tty'] as bool? ?? false,
  openStdin: json['OpenStdin'] as bool? ?? false,
  stdinOnce: json['StdinOnce'] as bool? ?? false,
  env: (json['Env'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  cmd: (json['Cmd'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  healthcheck: json['Healthcheck'] == null
      ? null
      : HealthConfig.fromJson(json['Healthcheck'] as Map<String, dynamic>),
  argsEscaped: json['ArgsEscaped'] as bool? ?? false,
  image: json['Image'] as String?,
  volumes: json['Volumes'] as Map<String, dynamic>?,
  workingDir: json['WorkingDir'] as String?,
  entrypoint:
      (json['Entrypoint'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  networkDisabled: json['NetworkDisabled'] as bool?,
  onBuild:
      (json['OnBuild'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  labels: json['Labels'] as Map<String, dynamic>?,
  stopSignal: json['StopSignal'] as String?,
  stopTimeout: (json['StopTimeout'] as num?)?.toInt(),
  shell:
      (json['Shell'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
);

Map<String, dynamic> _$ContainerConfigToJson(ContainerConfig instance) =>
    <String, dynamic>{
      'Hostname': instance.hostname,
      'Domainname': instance.domainname,
      'User': instance.user,
      'AttachStdin': instance.attachStdin,
      'AttachStdout': instance.attachStdout,
      'AttachStderr': instance.attachStderr,
      'ExposedPorts': instance.exposedPorts,
      'Tty': instance.tty,
      'OpenStdin': instance.openStdin,
      'StdinOnce': instance.stdinOnce,
      'Env': instance.env,
      'Cmd': instance.cmd,
      'Healthcheck': instance.healthcheck?.toJson(),
      'ArgsEscaped': instance.argsEscaped,
      'Image': instance.image,
      'Volumes': instance.volumes,
      'WorkingDir': instance.workingDir,
      'Entrypoint': instance.entrypoint,
      'NetworkDisabled': instance.networkDisabled,
      'OnBuild': instance.onBuild,
      'Labels': instance.labels,
      'StopSignal': instance.stopSignal,
      'StopTimeout': instance.stopTimeout,
      'Shell': instance.shell,
    };

ImageConfig _$ImageConfigFromJson(Map<String, dynamic> json) => ImageConfig(
  user: json['User'] as String?,
  exposedPorts: json['ExposedPorts'] as Map<String, dynamic>?,
  env: (json['Env'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  cmd: (json['Cmd'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  healthcheck: json['Healthcheck'] == null
      ? null
      : HealthConfig.fromJson(json['Healthcheck'] as Map<String, dynamic>),
  argsEscaped: json['ArgsEscaped'] as bool? ?? false,
  volumes: json['Volumes'] as Map<String, dynamic>?,
  workingDir: json['WorkingDir'] as String?,
  entrypoint:
      (json['Entrypoint'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  onBuild:
      (json['OnBuild'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  labels: json['Labels'] as Map<String, dynamic>?,
  stopSignal: json['StopSignal'] as String?,
  shell:
      (json['Shell'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
);

Map<String, dynamic> _$ImageConfigToJson(ImageConfig instance) =>
    <String, dynamic>{
      'User': instance.user,
      'ExposedPorts': instance.exposedPorts,
      'Env': instance.env,
      'Cmd': instance.cmd,
      'Healthcheck': instance.healthcheck?.toJson(),
      'ArgsEscaped': instance.argsEscaped,
      'Volumes': instance.volumes,
      'WorkingDir': instance.workingDir,
      'Entrypoint': instance.entrypoint,
      'OnBuild': instance.onBuild,
      'Labels': instance.labels,
      'StopSignal': instance.stopSignal,
      'Shell': instance.shell,
    };

NetworkingConfig _$NetworkingConfigFromJson(Map<String, dynamic> json) =>
    NetworkingConfig(
      endpointsConfig: json['EndpointsConfig'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NetworkingConfigToJson(NetworkingConfig instance) =>
    <String, dynamic>{'EndpointsConfig': instance.endpointsConfig};

NetworkSettings _$NetworkSettingsFromJson(Map<String, dynamic> json) =>
    NetworkSettings(
      sandboxID: json['SandboxID'] as String?,
      sandboxKey: json['SandboxKey'] as String?,
      ports: json['Ports'] == null
          ? null
          : PortMap.fromJson(json['Ports'] as Map<String, dynamic>),
      networks: json['Networks'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NetworkSettingsToJson(NetworkSettings instance) =>
    <String, dynamic>{
      'SandboxID': instance.sandboxID,
      'SandboxKey': instance.sandboxKey,
      'Ports': instance.ports?.toJson(),
      'Networks': instance.networks,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  addr: json['Addr'] as String?,
  prefixLen: (json['PrefixLen'] as num?)?.toInt(),
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'Addr': instance.addr,
  'PrefixLen': instance.prefixLen,
};

PortMap _$PortMapFromJson(Map<String, dynamic> json) => PortMap();

Map<String, dynamic> _$PortMapToJson(PortMap instance) => <String, dynamic>{};

PortBinding _$PortBindingFromJson(Map<String, dynamic> json) => PortBinding(
  hostIp: json['HostIp'] as String?,
  hostPort: json['HostPort'] as String?,
);

Map<String, dynamic> _$PortBindingToJson(PortBinding instance) =>
    <String, dynamic>{'HostIp': instance.hostIp, 'HostPort': instance.hostPort};

DriverData _$DriverDataFromJson(Map<String, dynamic> json) => DriverData(
  name: json['Name'] as String,
  data: json['Data'] as Map<String, dynamic>,
);

Map<String, dynamic> _$DriverDataToJson(DriverData instance) =>
    <String, dynamic>{'Name': instance.name, 'Data': instance.data};

Storage _$StorageFromJson(Map<String, dynamic> json) => Storage(
  rootFS: json['RootFS'] == null
      ? null
      : RootFSStorage.fromJson(json['RootFS'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StorageToJson(Storage instance) => <String, dynamic>{
  'RootFS': instance.rootFS?.toJson(),
};

RootFSStorage _$RootFSStorageFromJson(Map<String, dynamic> json) =>
    RootFSStorage(
      snapshot: json['Snapshot'] == null
          ? null
          : RootFSStorageSnapshot.fromJson(
              json['Snapshot'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RootFSStorageToJson(RootFSStorage instance) =>
    <String, dynamic>{'Snapshot': instance.snapshot?.toJson()};

RootFSStorageSnapshot _$RootFSStorageSnapshotFromJson(
  Map<String, dynamic> json,
) => RootFSStorageSnapshot(name: json['Name'] as String?);

Map<String, dynamic> _$RootFSStorageSnapshotToJson(
  RootFSStorageSnapshot instance,
) => <String, dynamic>{'Name': instance.name};

FilesystemChange _$FilesystemChangeFromJson(Map<String, dynamic> json) =>
    FilesystemChange(
      path: json['Path'] as String,
      kind: changeTypeFromJson(json['Kind']),
    );

Map<String, dynamic> _$FilesystemChangeToJson(FilesystemChange instance) =>
    <String, dynamic>{
      'Path': instance.path,
      'Kind': changeTypeToJson(instance.kind),
    };

ImageInspect _$ImageInspectFromJson(Map<String, dynamic> json) => ImageInspect(
  id: json['Id'] as String?,
  descriptor: json['Descriptor'] == null
      ? null
      : OCIDescriptor.fromJson(json['Descriptor'] as Map<String, dynamic>),
  manifests:
      (json['Manifests'] as List<dynamic>?)
          ?.map((e) => ImageManifestSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  identity: json['Identity'] == null
      ? null
      : Identity.fromJson(json['Identity'] as Map<String, dynamic>),
  repoTags:
      (json['RepoTags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  repoDigests:
      (json['RepoDigests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  comment: json['Comment'] as String?,
  created: json['Created'] as String?,
  author: json['Author'] as String?,
  config: json['Config'] == null
      ? null
      : ImageConfig.fromJson(json['Config'] as Map<String, dynamic>),
  architecture: json['Architecture'] as String?,
  variant: json['Variant'] as String?,
  os: json['Os'] as String?,
  osVersion: json['OsVersion'] as String?,
  size: (json['Size'] as num?)?.toInt(),
  graphDriver: json['GraphDriver'] == null
      ? null
      : DriverData.fromJson(json['GraphDriver'] as Map<String, dynamic>),
  rootFS: json['RootFS'] == null
      ? null
      : ImageInspect$RootFS.fromJson(json['RootFS'] as Map<String, dynamic>),
  metadata: json['Metadata'] == null
      ? null
      : ImageInspect$Metadata.fromJson(
          json['Metadata'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ImageInspectToJson(ImageInspect instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Descriptor': instance.descriptor?.toJson(),
      'Manifests': instance.manifests?.map((e) => e.toJson()).toList(),
      'Identity': instance.identity?.toJson(),
      'RepoTags': instance.repoTags,
      'RepoDigests': instance.repoDigests,
      'Comment': instance.comment,
      'Created': instance.created,
      'Author': instance.author,
      'Config': instance.config?.toJson(),
      'Architecture': instance.architecture,
      'Variant': instance.variant,
      'Os': instance.os,
      'OsVersion': instance.osVersion,
      'Size': instance.size,
      'GraphDriver': instance.graphDriver?.toJson(),
      'RootFS': instance.rootFS?.toJson(),
      'Metadata': instance.metadata?.toJson(),
    };

Identity _$IdentityFromJson(Map<String, dynamic> json) => Identity(
  signature:
      (json['Signature'] as List<dynamic>?)
          ?.map((e) => SignatureIdentity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  pull:
      (json['Pull'] as List<dynamic>?)
          ?.map((e) => PullIdentity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  build:
      (json['Build'] as List<dynamic>?)
          ?.map((e) => BuildIdentity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$IdentityToJson(Identity instance) => <String, dynamic>{
  'Signature': instance.signature?.map((e) => e.toJson()).toList(),
  'Pull': instance.pull?.map((e) => e.toJson()).toList(),
  'Build': instance.build?.map((e) => e.toJson()).toList(),
};

BuildIdentity _$BuildIdentityFromJson(Map<String, dynamic> json) =>
    BuildIdentity(
      ref: json['Ref'] as String?,
      createdAt: json['CreatedAt'] == null
          ? null
          : DateTime.parse(json['CreatedAt'] as String),
    );

Map<String, dynamic> _$BuildIdentityToJson(BuildIdentity instance) =>
    <String, dynamic>{
      'Ref': instance.ref,
      'CreatedAt': instance.createdAt?.toIso8601String(),
    };

PullIdentity _$PullIdentityFromJson(Map<String, dynamic> json) =>
    PullIdentity(repository: json['Repository'] as String?);

Map<String, dynamic> _$PullIdentityToJson(PullIdentity instance) =>
    <String, dynamic>{'Repository': instance.repository};

SignatureIdentity _$SignatureIdentityFromJson(
  Map<String, dynamic> json,
) => SignatureIdentity(
  name: json['Name'] as String?,
  timestamps:
      (json['Timestamps'] as List<dynamic>?)
          ?.map((e) => SignatureTimestamp.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  knownSigner: knownSignerIdentityNullableFromJson(json['KnownSigner']),
  dockerReference: json['DockerReference'] as String?,
  signer: json['Signer'] == null
      ? null
      : SignerIdentity.fromJson(json['Signer'] as Map<String, dynamic>),
  signatureType: signatureTypeNullableFromJson(json['SignatureType']),
  error: json['Error'] as String?,
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$SignatureIdentityToJson(SignatureIdentity instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Timestamps': instance.timestamps?.map((e) => e.toJson()).toList(),
      'KnownSigner': knownSignerIdentityNullableToJson(instance.knownSigner),
      'DockerReference': instance.dockerReference,
      'Signer': instance.signer?.toJson(),
      'SignatureType': signatureTypeNullableToJson(instance.signatureType),
      'Error': instance.error,
      'Warnings': instance.warnings,
    };

SignatureTimestamp _$SignatureTimestampFromJson(Map<String, dynamic> json) =>
    SignatureTimestamp(
      type: signatureTimestampTypeNullableFromJson(json['Type']),
      uri: json['URI'] as String?,
      timestamp: json['Timestamp'] == null
          ? null
          : DateTime.parse(json['Timestamp'] as String),
    );

Map<String, dynamic> _$SignatureTimestampToJson(SignatureTimestamp instance) =>
    <String, dynamic>{
      'Type': signatureTimestampTypeNullableToJson(instance.type),
      'URI': instance.uri,
      'Timestamp': instance.timestamp?.toIso8601String(),
    };

SignerIdentity _$SignerIdentityFromJson(Map<String, dynamic> json) =>
    SignerIdentity(
      certificateIssuer: json['CertificateIssuer'] as String?,
      subjectAlternativeName: json['SubjectAlternativeName'] as String?,
      issuer: json['Issuer'] as String?,
      buildSignerURI: json['BuildSignerURI'] as String?,
      buildSignerDigest: json['BuildSignerDigest'] as String?,
      runnerEnvironment: json['RunnerEnvironment'] as String?,
      sourceRepositoryURI: json['SourceRepositoryURI'] as String?,
      sourceRepositoryDigest: json['SourceRepositoryDigest'] as String?,
      sourceRepositoryRef: json['SourceRepositoryRef'] as String?,
      sourceRepositoryIdentifier: json['SourceRepositoryIdentifier'] as String?,
      sourceRepositoryOwnerURI: json['SourceRepositoryOwnerURI'] as String?,
      sourceRepositoryOwnerIdentifier:
          json['SourceRepositoryOwnerIdentifier'] as String?,
      buildConfigURI: json['BuildConfigURI'] as String?,
      buildConfigDigest: json['BuildConfigDigest'] as String?,
      buildTrigger: json['BuildTrigger'] as String?,
      runInvocationURI: json['RunInvocationURI'] as String?,
      sourceRepositoryVisibilityAtSigning:
          json['SourceRepositoryVisibilityAtSigning'] as String?,
    );

Map<String, dynamic> _$SignerIdentityToJson(
  SignerIdentity instance,
) => <String, dynamic>{
  'CertificateIssuer': instance.certificateIssuer,
  'SubjectAlternativeName': instance.subjectAlternativeName,
  'Issuer': instance.issuer,
  'BuildSignerURI': instance.buildSignerURI,
  'BuildSignerDigest': instance.buildSignerDigest,
  'RunnerEnvironment': instance.runnerEnvironment,
  'SourceRepositoryURI': instance.sourceRepositoryURI,
  'SourceRepositoryDigest': instance.sourceRepositoryDigest,
  'SourceRepositoryRef': instance.sourceRepositoryRef,
  'SourceRepositoryIdentifier': instance.sourceRepositoryIdentifier,
  'SourceRepositoryOwnerURI': instance.sourceRepositoryOwnerURI,
  'SourceRepositoryOwnerIdentifier': instance.sourceRepositoryOwnerIdentifier,
  'BuildConfigURI': instance.buildConfigURI,
  'BuildConfigDigest': instance.buildConfigDigest,
  'BuildTrigger': instance.buildTrigger,
  'RunInvocationURI': instance.runInvocationURI,
  'SourceRepositoryVisibilityAtSigning':
      instance.sourceRepositoryVisibilityAtSigning,
};

ImageSummary _$ImageSummaryFromJson(Map<String, dynamic> json) => ImageSummary(
  id: json['Id'] as String,
  parentId: json['ParentId'] as String,
  repoTags:
      (json['RepoTags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  repoDigests:
      (json['RepoDigests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  created: (json['Created'] as num).toInt(),
  size: (json['Size'] as num).toInt(),
  sharedSize: (json['SharedSize'] as num).toInt(),
  labels: json['Labels'] as Map<String, dynamic>,
  containers: (json['Containers'] as num).toInt(),
  manifests:
      (json['Manifests'] as List<dynamic>?)
          ?.map((e) => ImageManifestSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  descriptor: json['Descriptor'] == null
      ? null
      : OCIDescriptor.fromJson(json['Descriptor'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ImageSummaryToJson(ImageSummary instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'ParentId': instance.parentId,
      'RepoTags': instance.repoTags,
      'RepoDigests': instance.repoDigests,
      'Created': instance.created,
      'Size': instance.size,
      'SharedSize': instance.sharedSize,
      'Labels': instance.labels,
      'Containers': instance.containers,
      'Manifests': instance.manifests?.map((e) => e.toJson()).toList(),
      'Descriptor': instance.descriptor?.toJson(),
    };

ImagesDiskUsage _$ImagesDiskUsageFromJson(Map<String, dynamic> json) =>
    ImagesDiskUsage(
      activeCount: (json['ActiveCount'] as num?)?.toInt(),
      totalCount: (json['TotalCount'] as num?)?.toInt(),
      reclaimable: (json['Reclaimable'] as num?)?.toInt(),
      totalSize: (json['TotalSize'] as num?)?.toInt(),
      items:
          (json['Items'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
          [],
    );

Map<String, dynamic> _$ImagesDiskUsageToJson(ImagesDiskUsage instance) =>
    <String, dynamic>{
      'ActiveCount': instance.activeCount,
      'TotalCount': instance.totalCount,
      'Reclaimable': instance.reclaimable,
      'TotalSize': instance.totalSize,
      'Items': instance.items,
    };

AuthConfig _$AuthConfigFromJson(Map<String, dynamic> json) => AuthConfig(
  username: json['username'] as String?,
  password: json['password'] as String?,
  serveraddress: json['serveraddress'] as String?,
);

Map<String, dynamic> _$AuthConfigToJson(AuthConfig instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'serveraddress': instance.serveraddress,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  status: json['Status'] as String,
  identityToken: json['IdentityToken'] as String?,
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'Status': instance.status,
      'IdentityToken': instance.identityToken,
    };

ProcessConfig _$ProcessConfigFromJson(Map<String, dynamic> json) =>
    ProcessConfig(
      privileged: json['privileged'] as bool?,
      user: json['user'] as String?,
      tty: json['tty'] as bool?,
      entrypoint: json['entrypoint'] as String?,
      arguments:
          (json['arguments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ProcessConfigToJson(ProcessConfig instance) =>
    <String, dynamic>{
      'privileged': instance.privileged,
      'user': instance.user,
      'tty': instance.tty,
      'entrypoint': instance.entrypoint,
      'arguments': instance.arguments,
    };

Volume _$VolumeFromJson(Map<String, dynamic> json) => Volume(
  name: json['Name'] as String,
  driver: json['Driver'] as String,
  mountpoint: json['Mountpoint'] as String,
  createdAt: json['CreatedAt'] as String?,
  status: json['Status'] as Map<String, dynamic>?,
  labels: json['Labels'] as Map<String, dynamic>,
  scope: Volume.volumeScopeScopeFromJson(json['Scope']),
  clusterVolume: json['ClusterVolume'] == null
      ? null
      : ClusterVolume.fromJson(json['ClusterVolume'] as Map<String, dynamic>),
  options: json['Options'] as Map<String, dynamic>,
  usageData: json['UsageData'] == null
      ? null
      : Volume$UsageData.fromJson(json['UsageData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$VolumeToJson(Volume instance) => <String, dynamic>{
  'Name': instance.name,
  'Driver': instance.driver,
  'Mountpoint': instance.mountpoint,
  'CreatedAt': instance.createdAt,
  'Status': instance.status,
  'Labels': instance.labels,
  'Scope': volumeScopeToJson(instance.scope),
  'ClusterVolume': instance.clusterVolume?.toJson(),
  'Options': instance.options,
  'UsageData': instance.usageData?.toJson(),
};

VolumesDiskUsage _$VolumesDiskUsageFromJson(Map<String, dynamic> json) =>
    VolumesDiskUsage(
      activeCount: (json['ActiveCount'] as num?)?.toInt(),
      totalCount: (json['TotalCount'] as num?)?.toInt(),
      reclaimable: (json['Reclaimable'] as num?)?.toInt(),
      totalSize: (json['TotalSize'] as num?)?.toInt(),
      items:
          (json['Items'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
          [],
    );

Map<String, dynamic> _$VolumesDiskUsageToJson(VolumesDiskUsage instance) =>
    <String, dynamic>{
      'ActiveCount': instance.activeCount,
      'TotalCount': instance.totalCount,
      'Reclaimable': instance.reclaimable,
      'TotalSize': instance.totalSize,
      'Items': instance.items,
    };

VolumeCreateRequest _$VolumeCreateRequestFromJson(Map<String, dynamic> json) =>
    VolumeCreateRequest(
      name: json['Name'] as String?,
      driver: json['Driver'] as String?,
      driverOpts: json['DriverOpts'] as Map<String, dynamic>?,
      labels: json['Labels'] as Map<String, dynamic>?,
      clusterVolumeSpec: json['ClusterVolumeSpec'] == null
          ? null
          : ClusterVolumeSpec.fromJson(
              json['ClusterVolumeSpec'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$VolumeCreateRequestToJson(
  VolumeCreateRequest instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Driver': instance.driver,
  'DriverOpts': instance.driverOpts,
  'Labels': instance.labels,
  'ClusterVolumeSpec': instance.clusterVolumeSpec?.toJson(),
};

VolumeListResponse _$VolumeListResponseFromJson(Map<String, dynamic> json) =>
    VolumeListResponse(
      volumes:
          (json['Volumes'] as List<dynamic>?)
              ?.map((e) => Volume.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      warnings:
          (json['Warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$VolumeListResponseToJson(VolumeListResponse instance) =>
    <String, dynamic>{
      'Volumes': instance.volumes?.map((e) => e.toJson()).toList(),
      'Warnings': instance.warnings,
    };

Network _$NetworkFromJson(Map<String, dynamic> json) => Network(
  name: json['Name'] as String?,
  id: json['Id'] as String?,
  created: json['Created'] as String?,
  scope: json['Scope'] as String?,
  driver: json['Driver'] as String?,
  enableIPv4: json['EnableIPv4'] as bool?,
  enableIPv6: json['EnableIPv6'] as bool?,
  ipam: json['IPAM'] == null
      ? null
      : Ipam.fromJson(json['IPAM'] as Map<String, dynamic>),
  internal: json['Internal'] as bool? ?? false,
  attachable: json['Attachable'] as bool? ?? false,
  ingress: json['Ingress'] as bool? ?? false,
  configFrom: json['ConfigFrom'] == null
      ? null
      : ConfigReference.fromJson(json['ConfigFrom'] as Map<String, dynamic>),
  configOnly: json['ConfigOnly'] as bool? ?? false,
  options: json['Options'] as Map<String, dynamic>?,
  labels: json['Labels'] as Map<String, dynamic>?,
  peers:
      (json['Peers'] as List<dynamic>?)
          ?.map((e) => PeerInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$NetworkToJson(Network instance) => <String, dynamic>{
  'Name': instance.name,
  'Id': instance.id,
  'Created': instance.created,
  'Scope': instance.scope,
  'Driver': instance.driver,
  'EnableIPv4': instance.enableIPv4,
  'EnableIPv6': instance.enableIPv6,
  'IPAM': instance.ipam?.toJson(),
  'Internal': instance.internal,
  'Attachable': instance.attachable,
  'Ingress': instance.ingress,
  'ConfigFrom': instance.configFrom?.toJson(),
  'ConfigOnly': instance.configOnly,
  'Options': instance.options,
  'Labels': instance.labels,
  'Peers': instance.peers?.map((e) => e.toJson()).toList(),
};

NetworkSummary _$NetworkSummaryFromJson(Map<String, dynamic> json) =>
    NetworkSummary(
      name: json['Name'] as String?,
      id: json['Id'] as String?,
      created: json['Created'] as String?,
      scope: json['Scope'] as String?,
      driver: json['Driver'] as String?,
      enableIPv4: json['EnableIPv4'] as bool?,
      enableIPv6: json['EnableIPv6'] as bool?,
      ipam: json['IPAM'] == null
          ? null
          : Ipam.fromJson(json['IPAM'] as Map<String, dynamic>),
      internal: json['Internal'] as bool? ?? false,
      attachable: json['Attachable'] as bool? ?? false,
      ingress: json['Ingress'] as bool? ?? false,
      configFrom: json['ConfigFrom'] == null
          ? null
          : ConfigReference.fromJson(
              json['ConfigFrom'] as Map<String, dynamic>,
            ),
      configOnly: json['ConfigOnly'] as bool? ?? false,
      options: json['Options'] as Map<String, dynamic>?,
      labels: json['Labels'] as Map<String, dynamic>?,
      peers:
          (json['Peers'] as List<dynamic>?)
              ?.map((e) => PeerInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$NetworkSummaryToJson(NetworkSummary instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Id': instance.id,
      'Created': instance.created,
      'Scope': instance.scope,
      'Driver': instance.driver,
      'EnableIPv4': instance.enableIPv4,
      'EnableIPv6': instance.enableIPv6,
      'IPAM': instance.ipam?.toJson(),
      'Internal': instance.internal,
      'Attachable': instance.attachable,
      'Ingress': instance.ingress,
      'ConfigFrom': instance.configFrom?.toJson(),
      'ConfigOnly': instance.configOnly,
      'Options': instance.options,
      'Labels': instance.labels,
      'Peers': instance.peers?.map((e) => e.toJson()).toList(),
    };

NetworkInspect _$NetworkInspectFromJson(Map<String, dynamic> json) =>
    NetworkInspect(
      containers: json['Containers'] as Map<String, dynamic>?,
      services: json['Services'] as Map<String, dynamic>?,
      status: json['Status'] == null
          ? null
          : NetworkStatus.fromJson(json['Status'] as Map<String, dynamic>),
      name: json['Name'] as String?,
      id: json['Id'] as String?,
      created: json['Created'] as String?,
      scope: json['Scope'] as String?,
      driver: json['Driver'] as String?,
      enableIPv4: json['EnableIPv4'] as bool?,
      enableIPv6: json['EnableIPv6'] as bool?,
      ipam: json['IPAM'] == null
          ? null
          : Ipam.fromJson(json['IPAM'] as Map<String, dynamic>),
      internal: json['Internal'] as bool? ?? false,
      attachable: json['Attachable'] as bool? ?? false,
      ingress: json['Ingress'] as bool? ?? false,
      configFrom: json['ConfigFrom'] == null
          ? null
          : ConfigReference.fromJson(
              json['ConfigFrom'] as Map<String, dynamic>,
            ),
      configOnly: json['ConfigOnly'] as bool? ?? false,
      options: json['Options'] as Map<String, dynamic>?,
      labels: json['Labels'] as Map<String, dynamic>?,
      peers:
          (json['Peers'] as List<dynamic>?)
              ?.map((e) => PeerInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$NetworkInspectToJson(NetworkInspect instance) =>
    <String, dynamic>{
      'Containers': instance.containers,
      'Services': instance.services,
      'Status': instance.status?.toJson(),
      'Name': instance.name,
      'Id': instance.id,
      'Created': instance.created,
      'Scope': instance.scope,
      'Driver': instance.driver,
      'EnableIPv4': instance.enableIPv4,
      'EnableIPv6': instance.enableIPv6,
      'IPAM': instance.ipam?.toJson(),
      'Internal': instance.internal,
      'Attachable': instance.attachable,
      'Ingress': instance.ingress,
      'ConfigFrom': instance.configFrom?.toJson(),
      'ConfigOnly': instance.configOnly,
      'Options': instance.options,
      'Labels': instance.labels,
      'Peers': instance.peers?.map((e) => e.toJson()).toList(),
    };

NetworkStatus _$NetworkStatusFromJson(Map<String, dynamic> json) =>
    NetworkStatus(
      ipam: json['IPAM'] == null
          ? null
          : IPAMStatus.fromJson(json['IPAM'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NetworkStatusToJson(NetworkStatus instance) =>
    <String, dynamic>{'IPAM': instance.ipam?.toJson()};

ServiceInfo _$ServiceInfoFromJson(Map<String, dynamic> json) => ServiceInfo(
  vip: json['VIP'] as String?,
  ports:
      (json['Ports'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  localLBIndex: (json['LocalLBIndex'] as num?)?.toInt(),
  tasks:
      (json['Tasks'] as List<dynamic>?)
          ?.map((e) => NetworkTaskInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$ServiceInfoToJson(ServiceInfo instance) =>
    <String, dynamic>{
      'VIP': instance.vip,
      'Ports': instance.ports,
      'LocalLBIndex': instance.localLBIndex,
      'Tasks': instance.tasks?.map((e) => e.toJson()).toList(),
    };

NetworkTaskInfo _$NetworkTaskInfoFromJson(Map<String, dynamic> json) =>
    NetworkTaskInfo(
      name: json['Name'] as String?,
      endpointID: json['EndpointID'] as String?,
      endpointIP: json['EndpointIP'] as String?,
      info: json['Info'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$NetworkTaskInfoToJson(NetworkTaskInfo instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'EndpointID': instance.endpointID,
      'EndpointIP': instance.endpointIP,
      'Info': instance.info,
    };

ConfigReference _$ConfigReferenceFromJson(Map<String, dynamic> json) =>
    ConfigReference(network: json['Network'] as String?);

Map<String, dynamic> _$ConfigReferenceToJson(ConfigReference instance) =>
    <String, dynamic>{'Network': instance.network};

Ipam _$IpamFromJson(Map<String, dynamic> json) => Ipam(
  driver: json['Driver'] as String?,
  config:
      (json['Config'] as List<dynamic>?)
          ?.map((e) => IPAMConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  options: json['Options'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$IpamToJson(Ipam instance) => <String, dynamic>{
  'Driver': instance.driver,
  'Config': instance.config?.map((e) => e.toJson()).toList(),
  'Options': instance.options,
};

IPAMConfig _$IPAMConfigFromJson(Map<String, dynamic> json) => IPAMConfig(
  subnet: json['Subnet'] as String?,
  iPRange: json['IPRange'] as String?,
  gateway: json['Gateway'] as String?,
  auxiliaryAddresses: json['AuxiliaryAddresses'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$IPAMConfigToJson(IPAMConfig instance) =>
    <String, dynamic>{
      'Subnet': instance.subnet,
      'IPRange': instance.iPRange,
      'Gateway': instance.gateway,
      'AuxiliaryAddresses': instance.auxiliaryAddresses,
    };

IPAMStatus _$IPAMStatusFromJson(Map<String, dynamic> json) =>
    IPAMStatus(subnets: json['Subnets'] as Map<String, dynamic>?);

Map<String, dynamic> _$IPAMStatusToJson(IPAMStatus instance) =>
    <String, dynamic>{'Subnets': instance.subnets};

SubnetStatus _$SubnetStatusFromJson(Map<String, dynamic> json) => SubnetStatus(
  iPsInUse: (json['IPsInUse'] as num?)?.toInt(),
  dynamicIPsAvailable: (json['DynamicIPsAvailable'] as num?)?.toInt(),
);

Map<String, dynamic> _$SubnetStatusToJson(SubnetStatus instance) =>
    <String, dynamic>{
      'IPsInUse': instance.iPsInUse,
      'DynamicIPsAvailable': instance.dynamicIPsAvailable,
    };

EndpointResource _$EndpointResourceFromJson(Map<String, dynamic> json) =>
    EndpointResource(
      name: json['Name'] as String?,
      endpointID: json['EndpointID'] as String?,
      macAddress: json['MacAddress'] as String?,
      iPv4Address: json['IPv4Address'] as String?,
      iPv6Address: json['IPv6Address'] as String?,
    );

Map<String, dynamic> _$EndpointResourceToJson(EndpointResource instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'EndpointID': instance.endpointID,
      'MacAddress': instance.macAddress,
      'IPv4Address': instance.iPv4Address,
      'IPv6Address': instance.iPv6Address,
    };

PeerInfo _$PeerInfoFromJson(Map<String, dynamic> json) =>
    PeerInfo(name: json['Name'] as String?, ip: json['IP'] as String?);

Map<String, dynamic> _$PeerInfoToJson(PeerInfo instance) => <String, dynamic>{
  'Name': instance.name,
  'IP': instance.ip,
};

NetworkCreateResponse _$NetworkCreateResponseFromJson(
  Map<String, dynamic> json,
) => NetworkCreateResponse(
  id: json['Id'] as String,
  warning: json['Warning'] as String,
);

Map<String, dynamic> _$NetworkCreateResponseToJson(
  NetworkCreateResponse instance,
) => <String, dynamic>{'Id': instance.id, 'Warning': instance.warning};

BuildInfo _$BuildInfoFromJson(Map<String, dynamic> json) => BuildInfo(
  id: json['id'] as String?,
  stream: json['stream'] as String?,
  errorDetail: json['errorDetail'] == null
      ? null
      : ErrorDetail.fromJson(json['errorDetail'] as Map<String, dynamic>),
  status: json['status'] as String?,
  progressDetail: json['progressDetail'] == null
      ? null
      : ProgressDetail.fromJson(json['progressDetail'] as Map<String, dynamic>),
  aux: json['aux'] == null
      ? null
      : ImageID.fromJson(json['aux'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BuildInfoToJson(BuildInfo instance) => <String, dynamic>{
  'id': instance.id,
  'stream': instance.stream,
  'errorDetail': instance.errorDetail?.toJson(),
  'status': instance.status,
  'progressDetail': instance.progressDetail?.toJson(),
  'aux': instance.aux?.toJson(),
};

BuildCache _$BuildCacheFromJson(Map<String, dynamic> json) => BuildCache(
  id: json['ID'] as String?,
  parents:
      (json['Parents'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  type: buildCacheTypeNullableFromJson(json['Type']),
  description: json['Description'] as String?,
  inUse: json['InUse'] as bool?,
  shared: json['Shared'] as bool?,
  size: (json['Size'] as num?)?.toInt(),
  createdAt: json['CreatedAt'] as String?,
  lastUsedAt: json['LastUsedAt'] as String?,
  usageCount: (json['UsageCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$BuildCacheToJson(BuildCache instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Parents': instance.parents,
      'Type': buildCacheTypeNullableToJson(instance.type),
      'Description': instance.description,
      'InUse': instance.inUse,
      'Shared': instance.shared,
      'Size': instance.size,
      'CreatedAt': instance.createdAt,
      'LastUsedAt': instance.lastUsedAt,
      'UsageCount': instance.usageCount,
    };

BuildCacheDiskUsage _$BuildCacheDiskUsageFromJson(Map<String, dynamic> json) =>
    BuildCacheDiskUsage(
      activeCount: (json['ActiveCount'] as num?)?.toInt(),
      totalCount: (json['TotalCount'] as num?)?.toInt(),
      reclaimable: (json['Reclaimable'] as num?)?.toInt(),
      totalSize: (json['TotalSize'] as num?)?.toInt(),
      items:
          (json['Items'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
          [],
    );

Map<String, dynamic> _$BuildCacheDiskUsageToJson(
  BuildCacheDiskUsage instance,
) => <String, dynamic>{
  'ActiveCount': instance.activeCount,
  'TotalCount': instance.totalCount,
  'Reclaimable': instance.reclaimable,
  'TotalSize': instance.totalSize,
  'Items': instance.items,
};

ImageID _$ImageIDFromJson(Map<String, dynamic> json) =>
    ImageID(id: json['ID'] as String?);

Map<String, dynamic> _$ImageIDToJson(ImageID instance) => <String, dynamic>{
  'ID': instance.id,
};

CreateImageInfo _$CreateImageInfoFromJson(Map<String, dynamic> json) =>
    CreateImageInfo(
      id: json['id'] as String?,
      errorDetail: json['errorDetail'] == null
          ? null
          : ErrorDetail.fromJson(json['errorDetail'] as Map<String, dynamic>),
      status: json['status'] as String?,
      progressDetail: json['progressDetail'] == null
          ? null
          : ProgressDetail.fromJson(
              json['progressDetail'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CreateImageInfoToJson(CreateImageInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'errorDetail': instance.errorDetail?.toJson(),
      'status': instance.status,
      'progressDetail': instance.progressDetail?.toJson(),
    };

PushImageInfo _$PushImageInfoFromJson(Map<String, dynamic> json) =>
    PushImageInfo(
      errorDetail: json['errorDetail'] == null
          ? null
          : ErrorDetail.fromJson(json['errorDetail'] as Map<String, dynamic>),
      status: json['status'] as String?,
      progressDetail: json['progressDetail'] == null
          ? null
          : ProgressDetail.fromJson(
              json['progressDetail'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PushImageInfoToJson(PushImageInfo instance) =>
    <String, dynamic>{
      'errorDetail': instance.errorDetail?.toJson(),
      'status': instance.status,
      'progressDetail': instance.progressDetail?.toJson(),
    };

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) =>
    DeviceInfo(source: json['Source'] as String?, id: json['ID'] as String?);

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{'Source': instance.source, 'ID': instance.id};

NRIInfo _$NRIInfoFromJson(Map<String, dynamic> json) => NRIInfo(
  info:
      (json['Info'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
          .toList() ??
      [],
);

Map<String, dynamic> _$NRIInfoToJson(NRIInfo instance) => <String, dynamic>{
  'Info': instance.info,
};

ErrorDetail _$ErrorDetailFromJson(Map<String, dynamic> json) => ErrorDetail(
  code: (json['code'] as num?)?.toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ErrorDetailToJson(ErrorDetail instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

ProgressDetail _$ProgressDetailFromJson(Map<String, dynamic> json) =>
    ProgressDetail(
      current: (json['current'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProgressDetailToJson(ProgressDetail instance) =>
    <String, dynamic>{'current': instance.current, 'total': instance.total};

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(message: json['message'] as String);

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{'message': instance.message};

IDResponse _$IDResponseFromJson(Map<String, dynamic> json) =>
    IDResponse(id: json['Id'] as String);

Map<String, dynamic> _$IDResponseToJson(IDResponse instance) =>
    <String, dynamic>{'Id': instance.id};

NetworkConnectRequest _$NetworkConnectRequestFromJson(
  Map<String, dynamic> json,
) => NetworkConnectRequest(
  container: json['Container'] as String,
  endpointConfig: json['EndpointConfig'] == null
      ? null
      : EndpointSettings.fromJson(
          json['EndpointConfig'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$NetworkConnectRequestToJson(
  NetworkConnectRequest instance,
) => <String, dynamic>{
  'Container': instance.container,
  'EndpointConfig': instance.endpointConfig?.toJson(),
};

NetworkDisconnectRequest _$NetworkDisconnectRequestFromJson(
  Map<String, dynamic> json,
) => NetworkDisconnectRequest(
  container: json['Container'] as String,
  force: json['Force'] as bool? ?? false,
);

Map<String, dynamic> _$NetworkDisconnectRequestToJson(
  NetworkDisconnectRequest instance,
) => <String, dynamic>{
  'Container': instance.container,
  'Force': instance.force,
};

EndpointSettings _$EndpointSettingsFromJson(
  Map<String, dynamic> json,
) => EndpointSettings(
  iPAMConfig: json['IPAMConfig'] == null
      ? null
      : EndpointIPAMConfig.fromJson(json['IPAMConfig'] as Map<String, dynamic>),
  links:
      (json['Links'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  macAddress: json['MacAddress'] as String?,
  aliases:
      (json['Aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  driverOpts: json['DriverOpts'] as Map<String, dynamic>?,
  gwPriority: (json['GwPriority'] as num?)?.toInt(),
  networkID: json['NetworkID'] as String?,
  endpointID: json['EndpointID'] as String?,
  gateway: json['Gateway'] as String?,
  iPAddress: json['IPAddress'] as String?,
  iPPrefixLen: (json['IPPrefixLen'] as num?)?.toInt(),
  iPv6Gateway: json['IPv6Gateway'] as String?,
  globalIPv6Address: json['GlobalIPv6Address'] as String?,
  globalIPv6PrefixLen: (json['GlobalIPv6PrefixLen'] as num?)?.toInt(),
  dNSNames:
      (json['DNSNames'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$EndpointSettingsToJson(EndpointSettings instance) =>
    <String, dynamic>{
      'IPAMConfig': instance.iPAMConfig?.toJson(),
      'Links': instance.links,
      'MacAddress': instance.macAddress,
      'Aliases': instance.aliases,
      'DriverOpts': instance.driverOpts,
      'GwPriority': instance.gwPriority,
      'NetworkID': instance.networkID,
      'EndpointID': instance.endpointID,
      'Gateway': instance.gateway,
      'IPAddress': instance.iPAddress,
      'IPPrefixLen': instance.iPPrefixLen,
      'IPv6Gateway': instance.iPv6Gateway,
      'GlobalIPv6Address': instance.globalIPv6Address,
      'GlobalIPv6PrefixLen': instance.globalIPv6PrefixLen,
      'DNSNames': instance.dNSNames,
    };

EndpointIPAMConfig _$EndpointIPAMConfigFromJson(Map<String, dynamic> json) =>
    EndpointIPAMConfig(
      iPv4Address: json['IPv4Address'] as String?,
      iPv6Address: json['IPv6Address'] as String?,
      linkLocalIPs:
          (json['LinkLocalIPs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$EndpointIPAMConfigToJson(EndpointIPAMConfig instance) =>
    <String, dynamic>{
      'IPv4Address': instance.iPv4Address,
      'IPv6Address': instance.iPv6Address,
      'LinkLocalIPs': instance.linkLocalIPs,
    };

PluginMount _$PluginMountFromJson(Map<String, dynamic> json) => PluginMount(
  name: json['Name'] as String,
  description: json['Description'] as String,
  settable:
      (json['Settable'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  source: json['Source'] as String,
  destination: json['Destination'] as String,
  type: json['Type'] as String,
  options:
      (json['Options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$PluginMountToJson(PluginMount instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Description': instance.description,
      'Settable': instance.settable,
      'Source': instance.source,
      'Destination': instance.destination,
      'Type': instance.type,
      'Options': instance.options,
    };

PluginDevice _$PluginDeviceFromJson(Map<String, dynamic> json) => PluginDevice(
  name: json['Name'] as String,
  description: json['Description'] as String,
  settable:
      (json['Settable'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  path: json['Path'] as String,
);

Map<String, dynamic> _$PluginDeviceToJson(PluginDevice instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Description': instance.description,
      'Settable': instance.settable,
      'Path': instance.path,
    };

PluginEnv _$PluginEnvFromJson(Map<String, dynamic> json) => PluginEnv(
  name: json['Name'] as String,
  description: json['Description'] as String,
  settable:
      (json['Settable'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  $Value: json['Value'] as String,
);

Map<String, dynamic> _$PluginEnvToJson(PluginEnv instance) => <String, dynamic>{
  'Name': instance.name,
  'Description': instance.description,
  'Settable': instance.settable,
  'Value': instance.$Value,
};

PluginPrivilege _$PluginPrivilegeFromJson(Map<String, dynamic> json) =>
    PluginPrivilege(
      name: json['Name'] as String?,
      description: json['Description'] as String?,
      $Value:
          (json['Value'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );

Map<String, dynamic> _$PluginPrivilegeToJson(PluginPrivilege instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Description': instance.description,
      'Value': instance.$Value,
    };

Plugin _$PluginFromJson(Map<String, dynamic> json) => Plugin(
  id: json['Id'] as String?,
  name: json['Name'] as String,
  enabled: json['Enabled'] as bool,
  settings: Plugin$Settings.fromJson(json['Settings'] as Map<String, dynamic>),
  pluginReference: json['PluginReference'] as String?,
  config: Plugin$Config.fromJson(json['Config'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PluginToJson(Plugin instance) => <String, dynamic>{
  'Id': instance.id,
  'Name': instance.name,
  'Enabled': instance.enabled,
  'Settings': instance.settings.toJson(),
  'PluginReference': instance.pluginReference,
  'Config': instance.config.toJson(),
};

ObjectVersion _$ObjectVersionFromJson(Map<String, dynamic> json) =>
    ObjectVersion(index: (json['Index'] as num?)?.toInt());

Map<String, dynamic> _$ObjectVersionToJson(ObjectVersion instance) =>
    <String, dynamic>{'Index': instance.index};

NodeSpec _$NodeSpecFromJson(Map<String, dynamic> json) => NodeSpec(
  name: json['Name'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  role: nodeSpecRoleNullableFromJson(json['Role']),
  availability: nodeSpecAvailabilityNullableFromJson(json['Availability']),
);

Map<String, dynamic> _$NodeSpecToJson(NodeSpec instance) => <String, dynamic>{
  'Name': instance.name,
  'Labels': instance.labels,
  'Role': nodeSpecRoleNullableToJson(instance.role),
  'Availability': nodeSpecAvailabilityNullableToJson(instance.availability),
};

Node _$NodeFromJson(Map<String, dynamic> json) => Node(
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  spec: json['Spec'] == null
      ? null
      : NodeSpec.fromJson(json['Spec'] as Map<String, dynamic>),
  description: json['Description'] == null
      ? null
      : NodeDescription.fromJson(json['Description'] as Map<String, dynamic>),
  status: json['Status'] == null
      ? null
      : NodeStatus.fromJson(json['Status'] as Map<String, dynamic>),
  managerStatus: json['ManagerStatus'] == null
      ? null
      : ManagerStatus.fromJson(json['ManagerStatus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
  'ID': instance.id,
  'Version': instance.version?.toJson(),
  'CreatedAt': instance.createdAt,
  'UpdatedAt': instance.updatedAt,
  'Spec': instance.spec?.toJson(),
  'Description': instance.description?.toJson(),
  'Status': instance.status?.toJson(),
  'ManagerStatus': instance.managerStatus?.toJson(),
};

NodeDescription _$NodeDescriptionFromJson(Map<String, dynamic> json) =>
    NodeDescription(
      hostname: json['Hostname'] as String?,
      platform: json['Platform'] == null
          ? null
          : Platform.fromJson(json['Platform'] as Map<String, dynamic>),
      resources: json['Resources'] == null
          ? null
          : ResourceObject.fromJson(json['Resources'] as Map<String, dynamic>),
      engine: json['Engine'] == null
          ? null
          : EngineDescription.fromJson(json['Engine'] as Map<String, dynamic>),
      tLSInfo: json['TLSInfo'] == null
          ? null
          : TLSInfo.fromJson(json['TLSInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NodeDescriptionToJson(NodeDescription instance) =>
    <String, dynamic>{
      'Hostname': instance.hostname,
      'Platform': instance.platform?.toJson(),
      'Resources': instance.resources?.toJson(),
      'Engine': instance.engine?.toJson(),
      'TLSInfo': instance.tLSInfo?.toJson(),
    };

Platform _$PlatformFromJson(Map<String, dynamic> json) => Platform(
  architecture: json['Architecture'] as String?,
  os: json['OS'] as String?,
);

Map<String, dynamic> _$PlatformToJson(Platform instance) => <String, dynamic>{
  'Architecture': instance.architecture,
  'OS': instance.os,
};

EngineDescription _$EngineDescriptionFromJson(Map<String, dynamic> json) =>
    EngineDescription(
      engineVersion: json['EngineVersion'] as String?,
      labels: json['Labels'] as Map<String, dynamic>?,
      plugins: (json['Plugins'] as List<dynamic>?)
          ?.map(
            (e) => EngineDescription$Plugins$Item.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$EngineDescriptionToJson(EngineDescription instance) =>
    <String, dynamic>{
      'EngineVersion': instance.engineVersion,
      'Labels': instance.labels,
      'Plugins': instance.plugins?.map((e) => e.toJson()).toList(),
    };

TLSInfo _$TLSInfoFromJson(Map<String, dynamic> json) => TLSInfo(
  trustRoot: json['TrustRoot'] as String?,
  certIssuerSubject: json['CertIssuerSubject'] as String?,
  certIssuerPublicKey: json['CertIssuerPublicKey'] as String?,
);

Map<String, dynamic> _$TLSInfoToJson(TLSInfo instance) => <String, dynamic>{
  'TrustRoot': instance.trustRoot,
  'CertIssuerSubject': instance.certIssuerSubject,
  'CertIssuerPublicKey': instance.certIssuerPublicKey,
};

NodeStatus _$NodeStatusFromJson(Map<String, dynamic> json) => NodeStatus(
  state: nodeStateNullableFromJson(json['State']),
  message: json['Message'] as String?,
  addr: json['Addr'] as String?,
);

Map<String, dynamic> _$NodeStatusToJson(NodeStatus instance) =>
    <String, dynamic>{
      'State': nodeStateNullableToJson(instance.state),
      'Message': instance.message,
      'Addr': instance.addr,
    };

ManagerStatus _$ManagerStatusFromJson(Map<String, dynamic> json) =>
    ManagerStatus(
      leader: json['Leader'] as bool? ?? false,
      reachability: reachabilityNullableFromJson(json['Reachability']),
      addr: json['Addr'] as String?,
    );

Map<String, dynamic> _$ManagerStatusToJson(ManagerStatus instance) =>
    <String, dynamic>{
      'Leader': instance.leader,
      'Reachability': reachabilityNullableToJson(instance.reachability),
      'Addr': instance.addr,
    };

SwarmSpec _$SwarmSpecFromJson(Map<String, dynamic> json) => SwarmSpec(
  name: json['Name'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  orchestration: json['Orchestration'] == null
      ? null
      : SwarmSpec$Orchestration.fromJson(
          json['Orchestration'] as Map<String, dynamic>,
        ),
  raft: json['Raft'] == null
      ? null
      : SwarmSpec$Raft.fromJson(json['Raft'] as Map<String, dynamic>),
  dispatcher: json['Dispatcher'] == null
      ? null
      : SwarmSpec$Dispatcher.fromJson(
          json['Dispatcher'] as Map<String, dynamic>,
        ),
  cAConfig: json['CAConfig'] == null
      ? null
      : SwarmSpec$CAConfig.fromJson(json['CAConfig'] as Map<String, dynamic>),
  encryptionConfig: json['EncryptionConfig'] == null
      ? null
      : SwarmSpec$EncryptionConfig.fromJson(
          json['EncryptionConfig'] as Map<String, dynamic>,
        ),
  taskDefaults: json['TaskDefaults'] == null
      ? null
      : SwarmSpec$TaskDefaults.fromJson(
          json['TaskDefaults'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SwarmSpecToJson(SwarmSpec instance) => <String, dynamic>{
  'Name': instance.name,
  'Labels': instance.labels,
  'Orchestration': instance.orchestration?.toJson(),
  'Raft': instance.raft?.toJson(),
  'Dispatcher': instance.dispatcher?.toJson(),
  'CAConfig': instance.cAConfig?.toJson(),
  'EncryptionConfig': instance.encryptionConfig?.toJson(),
  'TaskDefaults': instance.taskDefaults?.toJson(),
};

ClusterInfo _$ClusterInfoFromJson(Map<String, dynamic> json) => ClusterInfo(
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  spec: json['Spec'] == null
      ? null
      : SwarmSpec.fromJson(json['Spec'] as Map<String, dynamic>),
  tLSInfo: json['TLSInfo'] == null
      ? null
      : TLSInfo.fromJson(json['TLSInfo'] as Map<String, dynamic>),
  rootRotationInProgress: json['RootRotationInProgress'] as bool?,
  dataPathPort: (json['DataPathPort'] as num?)?.toInt(),
  defaultAddrPool:
      (json['DefaultAddrPool'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  subnetSize: (json['SubnetSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$ClusterInfoToJson(ClusterInfo instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Version': instance.version?.toJson(),
      'CreatedAt': instance.createdAt,
      'UpdatedAt': instance.updatedAt,
      'Spec': instance.spec?.toJson(),
      'TLSInfo': instance.tLSInfo?.toJson(),
      'RootRotationInProgress': instance.rootRotationInProgress,
      'DataPathPort': instance.dataPathPort,
      'DefaultAddrPool': instance.defaultAddrPool,
      'SubnetSize': instance.subnetSize,
    };

JoinTokens _$JoinTokensFromJson(Map<String, dynamic> json) => JoinTokens(
  worker: json['Worker'] as String?,
  manager: json['Manager'] as String?,
);

Map<String, dynamic> _$JoinTokensToJson(JoinTokens instance) =>
    <String, dynamic>{'Worker': instance.worker, 'Manager': instance.manager};

Swarm _$SwarmFromJson(Map<String, dynamic> json) => Swarm(
  joinTokens: json['JoinTokens'] == null
      ? null
      : JoinTokens.fromJson(json['JoinTokens'] as Map<String, dynamic>),
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  spec: json['Spec'] == null
      ? null
      : SwarmSpec.fromJson(json['Spec'] as Map<String, dynamic>),
  tLSInfo: json['TLSInfo'] == null
      ? null
      : TLSInfo.fromJson(json['TLSInfo'] as Map<String, dynamic>),
  rootRotationInProgress: json['RootRotationInProgress'] as bool?,
  dataPathPort: (json['DataPathPort'] as num?)?.toInt(),
  defaultAddrPool:
      (json['DefaultAddrPool'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  subnetSize: (json['SubnetSize'] as num?)?.toInt(),
);

Map<String, dynamic> _$SwarmToJson(Swarm instance) => <String, dynamic>{
  'JoinTokens': instance.joinTokens?.toJson(),
  'ID': instance.id,
  'Version': instance.version?.toJson(),
  'CreatedAt': instance.createdAt,
  'UpdatedAt': instance.updatedAt,
  'Spec': instance.spec?.toJson(),
  'TLSInfo': instance.tLSInfo?.toJson(),
  'RootRotationInProgress': instance.rootRotationInProgress,
  'DataPathPort': instance.dataPathPort,
  'DefaultAddrPool': instance.defaultAddrPool,
  'SubnetSize': instance.subnetSize,
};

TaskSpec _$TaskSpecFromJson(Map<String, dynamic> json) => TaskSpec(
  pluginSpec: json['PluginSpec'] == null
      ? null
      : TaskSpec$PluginSpec.fromJson(
          json['PluginSpec'] as Map<String, dynamic>,
        ),
  containerSpec: json['ContainerSpec'] == null
      ? null
      : TaskSpec$ContainerSpec.fromJson(
          json['ContainerSpec'] as Map<String, dynamic>,
        ),
  networkAttachmentSpec: json['NetworkAttachmentSpec'] == null
      ? null
      : TaskSpec$NetworkAttachmentSpec.fromJson(
          json['NetworkAttachmentSpec'] as Map<String, dynamic>,
        ),
  resources: json['Resources'] == null
      ? null
      : TaskSpec$Resources.fromJson(json['Resources'] as Map<String, dynamic>),
  restartPolicy: json['RestartPolicy'] == null
      ? null
      : TaskSpec$RestartPolicy.fromJson(
          json['RestartPolicy'] as Map<String, dynamic>,
        ),
  placement: json['Placement'] == null
      ? null
      : TaskSpec$Placement.fromJson(json['Placement'] as Map<String, dynamic>),
  forceUpdate: (json['ForceUpdate'] as num?)?.toInt(),
  runtime: json['Runtime'] as String?,
  networks:
      (json['Networks'] as List<dynamic>?)
          ?.map(
            (e) => NetworkAttachmentConfig.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  logDriver: json['LogDriver'] == null
      ? null
      : TaskSpec$LogDriver.fromJson(json['LogDriver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TaskSpecToJson(TaskSpec instance) => <String, dynamic>{
  'PluginSpec': instance.pluginSpec?.toJson(),
  'ContainerSpec': instance.containerSpec?.toJson(),
  'NetworkAttachmentSpec': instance.networkAttachmentSpec?.toJson(),
  'Resources': instance.resources?.toJson(),
  'RestartPolicy': instance.restartPolicy?.toJson(),
  'Placement': instance.placement?.toJson(),
  'ForceUpdate': instance.forceUpdate,
  'Runtime': instance.runtime,
  'Networks': instance.networks?.map((e) => e.toJson()).toList(),
  'LogDriver': instance.logDriver?.toJson(),
};

ContainerStatus _$ContainerStatusFromJson(Map<String, dynamic> json) =>
    ContainerStatus(
      containerID: json['ContainerID'] as String?,
      pid: (json['PID'] as num?)?.toInt(),
      exitCode: (json['ExitCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContainerStatusToJson(ContainerStatus instance) =>
    <String, dynamic>{
      'ContainerID': instance.containerID,
      'PID': instance.pid,
      'ExitCode': instance.exitCode,
    };

PortStatus _$PortStatusFromJson(Map<String, dynamic> json) => PortStatus(
  ports:
      (json['Ports'] as List<dynamic>?)
          ?.map((e) => EndpointPortConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$PortStatusToJson(PortStatus instance) =>
    <String, dynamic>{'Ports': instance.ports?.map((e) => e.toJson()).toList()};

TaskStatus _$TaskStatusFromJson(Map<String, dynamic> json) => TaskStatus(
  timestamp: json['Timestamp'] as String?,
  state: taskStateNullableFromJson(json['State']),
  message: json['Message'] as String?,
  err: json['Err'] as String?,
  containerStatus: json['ContainerStatus'] == null
      ? null
      : ContainerStatus.fromJson(
          json['ContainerStatus'] as Map<String, dynamic>,
        ),
  portStatus: json['PortStatus'] == null
      ? null
      : PortStatus.fromJson(json['PortStatus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TaskStatusToJson(TaskStatus instance) =>
    <String, dynamic>{
      'Timestamp': instance.timestamp,
      'State': taskStateNullableToJson(instance.state),
      'Message': instance.message,
      'Err': instance.err,
      'ContainerStatus': instance.containerStatus?.toJson(),
      'PortStatus': instance.portStatus?.toJson(),
    };

NetworkAttachment _$NetworkAttachmentFromJson(Map<String, dynamic> json) =>
    NetworkAttachment(
      network: json['Network'] == null
          ? null
          : Network.fromJson(json['Network'] as Map<String, dynamic>),
      addresses:
          (json['Addresses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$NetworkAttachmentToJson(NetworkAttachment instance) =>
    <String, dynamic>{
      'Network': instance.network?.toJson(),
      'Addresses': instance.addresses,
    };

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  name: json['Name'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  spec: json['Spec'] == null
      ? null
      : TaskSpec.fromJson(json['Spec'] as Map<String, dynamic>),
  serviceID: json['ServiceID'] as String?,
  slot: (json['Slot'] as num?)?.toInt(),
  nodeID: json['NodeID'] as String?,
  assignedGenericResources: (json['AssignedGenericResources'] as List<dynamic>?)
      ?.map((e) => GenericResources$Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['Status'] == null
      ? null
      : TaskStatus.fromJson(json['Status'] as Map<String, dynamic>),
  desiredState: taskStateNullableFromJson(json['DesiredState']),
  jobIteration: json['JobIteration'] == null
      ? null
      : ObjectVersion.fromJson(json['JobIteration'] as Map<String, dynamic>),
  networksAttachments:
      (json['NetworksAttachments'] as List<dynamic>?)
          ?.map((e) => NetworkAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'ID': instance.id,
  'Version': instance.version?.toJson(),
  'CreatedAt': instance.createdAt,
  'UpdatedAt': instance.updatedAt,
  'Name': instance.name,
  'Labels': instance.labels,
  'Spec': instance.spec?.toJson(),
  'ServiceID': instance.serviceID,
  'Slot': instance.slot,
  'NodeID': instance.nodeID,
  'AssignedGenericResources': instance.assignedGenericResources
      ?.map((e) => e.toJson())
      .toList(),
  'Status': instance.status?.toJson(),
  'DesiredState': taskStateNullableToJson(instance.desiredState),
  'JobIteration': instance.jobIteration?.toJson(),
  'NetworksAttachments': instance.networksAttachments
      ?.map((e) => e.toJson())
      .toList(),
};

ServiceSpec _$ServiceSpecFromJson(Map<String, dynamic> json) => ServiceSpec(
  name: json['Name'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  taskTemplate: json['TaskTemplate'] == null
      ? null
      : TaskSpec.fromJson(json['TaskTemplate'] as Map<String, dynamic>),
  mode: json['Mode'] == null
      ? null
      : ServiceSpec$Mode.fromJson(json['Mode'] as Map<String, dynamic>),
  updateConfig: json['UpdateConfig'] == null
      ? null
      : ServiceSpec$UpdateConfig.fromJson(
          json['UpdateConfig'] as Map<String, dynamic>,
        ),
  rollbackConfig: json['RollbackConfig'] == null
      ? null
      : ServiceSpec$RollbackConfig.fromJson(
          json['RollbackConfig'] as Map<String, dynamic>,
        ),
  networks:
      (json['Networks'] as List<dynamic>?)
          ?.map(
            (e) => NetworkAttachmentConfig.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  endpointSpec: json['EndpointSpec'] == null
      ? null
      : EndpointSpec.fromJson(json['EndpointSpec'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ServiceSpecToJson(ServiceSpec instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Labels': instance.labels,
      'TaskTemplate': instance.taskTemplate?.toJson(),
      'Mode': instance.mode?.toJson(),
      'UpdateConfig': instance.updateConfig?.toJson(),
      'RollbackConfig': instance.rollbackConfig?.toJson(),
      'Networks': instance.networks?.map((e) => e.toJson()).toList(),
      'EndpointSpec': instance.endpointSpec?.toJson(),
    };

EndpointPortConfig _$EndpointPortConfigFromJson(
  Map<String, dynamic> json,
) => EndpointPortConfig(
  name: json['Name'] as String?,
  protocol: endpointPortConfigProtocolNullableFromJson(json['Protocol']),
  targetPort: (json['TargetPort'] as num?)?.toInt(),
  publishedPort: (json['PublishedPort'] as num?)?.toInt(),
  publishMode:
      EndpointPortConfig.endpointPortConfigPublishModePublishModeNullableFromJson(
        json['PublishMode'],
      ),
);

Map<String, dynamic> _$EndpointPortConfigToJson(EndpointPortConfig instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Protocol': endpointPortConfigProtocolNullableToJson(instance.protocol),
      'TargetPort': instance.targetPort,
      'PublishedPort': instance.publishedPort,
      'PublishMode': endpointPortConfigPublishModeNullableToJson(
        instance.publishMode,
      ),
    };

EndpointSpec _$EndpointSpecFromJson(Map<String, dynamic> json) => EndpointSpec(
  mode: EndpointSpec.endpointSpecModeModeNullableFromJson(json['Mode']),
  ports:
      (json['Ports'] as List<dynamic>?)
          ?.map((e) => EndpointPortConfig.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$EndpointSpecToJson(EndpointSpec instance) =>
    <String, dynamic>{
      'Mode': endpointSpecModeNullableToJson(instance.mode),
      'Ports': instance.ports?.map((e) => e.toJson()).toList(),
    };

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  spec: json['Spec'] == null
      ? null
      : ServiceSpec.fromJson(json['Spec'] as Map<String, dynamic>),
  endpoint: json['Endpoint'] == null
      ? null
      : Service$Endpoint.fromJson(json['Endpoint'] as Map<String, dynamic>),
  updateStatus: json['UpdateStatus'] == null
      ? null
      : Service$UpdateStatus.fromJson(
          json['UpdateStatus'] as Map<String, dynamic>,
        ),
  serviceStatus: json['ServiceStatus'] == null
      ? null
      : Service$ServiceStatus.fromJson(
          json['ServiceStatus'] as Map<String, dynamic>,
        ),
  jobStatus: json['JobStatus'] == null
      ? null
      : Service$JobStatus.fromJson(json['JobStatus'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
  'ID': instance.id,
  'Version': instance.version?.toJson(),
  'CreatedAt': instance.createdAt,
  'UpdatedAt': instance.updatedAt,
  'Spec': instance.spec?.toJson(),
  'Endpoint': instance.endpoint?.toJson(),
  'UpdateStatus': instance.updateStatus?.toJson(),
  'ServiceStatus': instance.serviceStatus?.toJson(),
  'JobStatus': instance.jobStatus?.toJson(),
};

ImageDeleteResponseItem _$ImageDeleteResponseItemFromJson(
  Map<String, dynamic> json,
) => ImageDeleteResponseItem(
  untagged: json['Untagged'] as String?,
  deleted: json['Deleted'] as String?,
);

Map<String, dynamic> _$ImageDeleteResponseItemToJson(
  ImageDeleteResponseItem instance,
) => <String, dynamic>{
  'Untagged': instance.untagged,
  'Deleted': instance.deleted,
};

ServiceCreateResponse _$ServiceCreateResponseFromJson(
  Map<String, dynamic> json,
) => ServiceCreateResponse(
  id: json['ID'] as String?,
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$ServiceCreateResponseToJson(
  ServiceCreateResponse instance,
) => <String, dynamic>{'ID': instance.id, 'Warnings': instance.warnings};

ServiceUpdateResponse _$ServiceUpdateResponseFromJson(
  Map<String, dynamic> json,
) => ServiceUpdateResponse(
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$ServiceUpdateResponseToJson(
  ServiceUpdateResponse instance,
) => <String, dynamic>{'Warnings': instance.warnings};

ContainerInspectResponse _$ContainerInspectResponseFromJson(
  Map<String, dynamic> json,
) => ContainerInspectResponse(
  id: json['Id'] as String?,
  created: json['Created'] as String?,
  path: json['Path'] as String?,
  args:
      (json['Args'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  state: json['State'] == null
      ? null
      : ContainerState.fromJson(json['State'] as Map<String, dynamic>),
  image: json['Image'] as String?,
  resolvConfPath: json['ResolvConfPath'] as String?,
  hostnamePath: json['HostnamePath'] as String?,
  hostsPath: json['HostsPath'] as String?,
  logPath: json['LogPath'] as String?,
  name: json['Name'] as String?,
  restartCount: (json['RestartCount'] as num?)?.toInt(),
  driver: json['Driver'] as String?,
  platform: json['Platform'] as String?,
  imageManifestDescriptor: json['ImageManifestDescriptor'] == null
      ? null
      : OCIDescriptor.fromJson(
          json['ImageManifestDescriptor'] as Map<String, dynamic>,
        ),
  mountLabel: json['MountLabel'] as String?,
  processLabel: json['ProcessLabel'] as String?,
  appArmorProfile: json['AppArmorProfile'] as String?,
  execIDs:
      (json['ExecIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  hostConfig: json['HostConfig'] == null
      ? null
      : HostConfig.fromJson(json['HostConfig'] as Map<String, dynamic>),
  graphDriver: json['GraphDriver'] == null
      ? null
      : DriverData.fromJson(json['GraphDriver'] as Map<String, dynamic>),
  storage: json['Storage'] == null
      ? null
      : Storage.fromJson(json['Storage'] as Map<String, dynamic>),
  sizeRw: (json['SizeRw'] as num?)?.toInt(),
  sizeRootFs: (json['SizeRootFs'] as num?)?.toInt(),
  mounts:
      (json['Mounts'] as List<dynamic>?)
          ?.map((e) => MountPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  config: json['Config'] == null
      ? null
      : ContainerConfig.fromJson(json['Config'] as Map<String, dynamic>),
  networkSettings: json['NetworkSettings'] == null
      ? null
      : NetworkSettings.fromJson(
          json['NetworkSettings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ContainerInspectResponseToJson(
  ContainerInspectResponse instance,
) => <String, dynamic>{
  'Id': instance.id,
  'Created': instance.created,
  'Path': instance.path,
  'Args': instance.args,
  'State': instance.state?.toJson(),
  'Image': instance.image,
  'ResolvConfPath': instance.resolvConfPath,
  'HostnamePath': instance.hostnamePath,
  'HostsPath': instance.hostsPath,
  'LogPath': instance.logPath,
  'Name': instance.name,
  'RestartCount': instance.restartCount,
  'Driver': instance.driver,
  'Platform': instance.platform,
  'ImageManifestDescriptor': instance.imageManifestDescriptor?.toJson(),
  'MountLabel': instance.mountLabel,
  'ProcessLabel': instance.processLabel,
  'AppArmorProfile': instance.appArmorProfile,
  'ExecIDs': instance.execIDs,
  'HostConfig': instance.hostConfig?.toJson(),
  'GraphDriver': instance.graphDriver?.toJson(),
  'Storage': instance.storage?.toJson(),
  'SizeRw': instance.sizeRw,
  'SizeRootFs': instance.sizeRootFs,
  'Mounts': instance.mounts?.map((e) => e.toJson()).toList(),
  'Config': instance.config?.toJson(),
  'NetworkSettings': instance.networkSettings?.toJson(),
};

ContainerSummary _$ContainerSummaryFromJson(Map<String, dynamic> json) =>
    ContainerSummary(
      id: json['Id'] as String?,
      names:
          (json['Names'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      image: json['Image'] as String?,
      imageID: json['ImageID'] as String?,
      imageManifestDescriptor: json['ImageManifestDescriptor'] == null
          ? null
          : OCIDescriptor.fromJson(
              json['ImageManifestDescriptor'] as Map<String, dynamic>,
            ),
      command: json['Command'] as String?,
      created: (json['Created'] as num?)?.toInt(),
      ports:
          (json['Ports'] as List<dynamic>?)
              ?.map((e) => PortSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      sizeRw: (json['SizeRw'] as num?)?.toInt(),
      sizeRootFs: (json['SizeRootFs'] as num?)?.toInt(),
      labels: json['Labels'] as Map<String, dynamic>?,
      state: containerSummaryStateNullableFromJson(json['State']),
      status: json['Status'] as String?,
      hostConfig: json['HostConfig'] == null
          ? null
          : ContainerSummary$HostConfig.fromJson(
              json['HostConfig'] as Map<String, dynamic>,
            ),
      networkSettings: json['NetworkSettings'] == null
          ? null
          : ContainerSummary$NetworkSettings.fromJson(
              json['NetworkSettings'] as Map<String, dynamic>,
            ),
      mounts:
          (json['Mounts'] as List<dynamic>?)
              ?.map((e) => MountPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      health: json['Health'] == null
          ? null
          : ContainerSummary$Health.fromJson(
              json['Health'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ContainerSummaryToJson(ContainerSummary instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Names': instance.names,
      'Image': instance.image,
      'ImageID': instance.imageID,
      'ImageManifestDescriptor': instance.imageManifestDescriptor?.toJson(),
      'Command': instance.command,
      'Created': instance.created,
      'Ports': instance.ports?.map((e) => e.toJson()).toList(),
      'SizeRw': instance.sizeRw,
      'SizeRootFs': instance.sizeRootFs,
      'Labels': instance.labels,
      'State': containerSummaryStateNullableToJson(instance.state),
      'Status': instance.status,
      'HostConfig': instance.hostConfig?.toJson(),
      'NetworkSettings': instance.networkSettings?.toJson(),
      'Mounts': instance.mounts?.map((e) => e.toJson()).toList(),
      'Health': instance.health?.toJson(),
    };

ContainersDiskUsage _$ContainersDiskUsageFromJson(Map<String, dynamic> json) =>
    ContainersDiskUsage(
      activeCount: (json['ActiveCount'] as num?)?.toInt(),
      totalCount: (json['TotalCount'] as num?)?.toInt(),
      reclaimable: (json['Reclaimable'] as num?)?.toInt(),
      totalSize: (json['TotalSize'] as num?)?.toInt(),
      items:
          (json['Items'] as List<dynamic>?)?.map((e) => e as Object).toList() ??
          [],
    );

Map<String, dynamic> _$ContainersDiskUsageToJson(
  ContainersDiskUsage instance,
) => <String, dynamic>{
  'ActiveCount': instance.activeCount,
  'TotalCount': instance.totalCount,
  'Reclaimable': instance.reclaimable,
  'TotalSize': instance.totalSize,
  'Items': instance.items,
};

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
  name: json['Name'] as String,
  options: json['Options'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
  'Name': instance.name,
  'Options': instance.options,
};

SecretSpec _$SecretSpecFromJson(Map<String, dynamic> json) => SecretSpec(
  name: json['Name'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  data: json['Data'] as String?,
  driver: json['Driver'] == null
      ? null
      : Driver.fromJson(json['Driver'] as Map<String, dynamic>),
  templating: json['Templating'] == null
      ? null
      : Driver.fromJson(json['Templating'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SecretSpecToJson(SecretSpec instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Labels': instance.labels,
      'Data': instance.data,
      'Driver': instance.driver?.toJson(),
      'Templating': instance.templating?.toJson(),
    };

Secret _$SecretFromJson(Map<String, dynamic> json) => Secret(
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  spec: json['Spec'] == null
      ? null
      : SecretSpec.fromJson(json['Spec'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SecretToJson(Secret instance) => <String, dynamic>{
  'ID': instance.id,
  'Version': instance.version?.toJson(),
  'CreatedAt': instance.createdAt,
  'UpdatedAt': instance.updatedAt,
  'Spec': instance.spec?.toJson(),
};

ConfigSpec _$ConfigSpecFromJson(Map<String, dynamic> json) => ConfigSpec(
  name: json['Name'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  data: json['Data'] as String?,
  templating: json['Templating'] == null
      ? null
      : Driver.fromJson(json['Templating'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ConfigSpecToJson(ConfigSpec instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Labels': instance.labels,
      'Data': instance.data,
      'Templating': instance.templating?.toJson(),
    };

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
  id: json['ID'] as String?,
  version: json['Version'] == null
      ? null
      : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
  createdAt: json['CreatedAt'] as String?,
  updatedAt: json['UpdatedAt'] as String?,
  spec: json['Spec'] == null
      ? null
      : ConfigSpec.fromJson(json['Spec'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
  'ID': instance.id,
  'Version': instance.version?.toJson(),
  'CreatedAt': instance.createdAt,
  'UpdatedAt': instance.updatedAt,
  'Spec': instance.spec?.toJson(),
};

ContainerState _$ContainerStateFromJson(Map<String, dynamic> json) =>
    ContainerState(
      status: containerStateStatusNullableFromJson(json['Status']),
      running: json['Running'] as bool?,
      paused: json['Paused'] as bool?,
      restarting: json['Restarting'] as bool?,
      oOMKilled: json['OOMKilled'] as bool?,
      dead: json['Dead'] as bool?,
      pid: (json['Pid'] as num?)?.toInt(),
      exitCode: (json['ExitCode'] as num?)?.toInt(),
      error: json['Error'] as String?,
      startedAt: json['StartedAt'] as String?,
      finishedAt: json['FinishedAt'] as String?,
      health: json['Health'] == null
          ? null
          : Health.fromJson(json['Health'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContainerStateToJson(ContainerState instance) =>
    <String, dynamic>{
      'Status': containerStateStatusNullableToJson(instance.status),
      'Running': instance.running,
      'Paused': instance.paused,
      'Restarting': instance.restarting,
      'OOMKilled': instance.oOMKilled,
      'Dead': instance.dead,
      'Pid': instance.pid,
      'ExitCode': instance.exitCode,
      'Error': instance.error,
      'StartedAt': instance.startedAt,
      'FinishedAt': instance.finishedAt,
      'Health': instance.health?.toJson(),
    };

ContainerCreateResponse _$ContainerCreateResponseFromJson(
  Map<String, dynamic> json,
) => ContainerCreateResponse(
  id: json['Id'] as String,
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$ContainerCreateResponseToJson(
  ContainerCreateResponse instance,
) => <String, dynamic>{'Id': instance.id, 'Warnings': instance.warnings};

ContainerUpdateResponse _$ContainerUpdateResponseFromJson(
  Map<String, dynamic> json,
) => ContainerUpdateResponse(
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$ContainerUpdateResponseToJson(
  ContainerUpdateResponse instance,
) => <String, dynamic>{'Warnings': instance.warnings};

ContainerStatsResponse _$ContainerStatsResponseFromJson(
  Map<String, dynamic> json,
) => ContainerStatsResponse(
  id: json['id'] as String?,
  name: json['name'] as String?,
  osType: json['os_type'] as String?,
  read: json['read'] == null ? null : DateTime.parse(json['read'] as String),
  cpuStats: json['cpu_stats'] == null
      ? null
      : ContainerCPUStats.fromJson(json['cpu_stats'] as Map<String, dynamic>),
  memoryStats: json['memory_stats'] == null
      ? null
      : ContainerMemoryStats.fromJson(
          json['memory_stats'] as Map<String, dynamic>,
        ),
  networks: json['networks'],
  pidsStats: json['pids_stats'] == null
      ? null
      : ContainerPidsStats.fromJson(json['pids_stats'] as Map<String, dynamic>),
  blkioStats: json['blkio_stats'] == null
      ? null
      : ContainerBlkioStats.fromJson(
          json['blkio_stats'] as Map<String, dynamic>,
        ),
  numProcs: (json['num_procs'] as num?)?.toInt(),
  storageStats: json['storage_stats'] == null
      ? null
      : ContainerStorageStats.fromJson(
          json['storage_stats'] as Map<String, dynamic>,
        ),
  preread: json['preread'] == null
      ? null
      : DateTime.parse(json['preread'] as String),
  precpuStats: json['precpu_stats'] == null
      ? null
      : ContainerCPUStats.fromJson(
          json['precpu_stats'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ContainerStatsResponseToJson(
  ContainerStatsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'os_type': instance.osType,
  'read': instance.read?.toIso8601String(),
  'cpu_stats': instance.cpuStats?.toJson(),
  'memory_stats': instance.memoryStats?.toJson(),
  'networks': instance.networks,
  'pids_stats': instance.pidsStats?.toJson(),
  'blkio_stats': instance.blkioStats?.toJson(),
  'num_procs': instance.numProcs,
  'storage_stats': instance.storageStats?.toJson(),
  'preread': instance.preread?.toIso8601String(),
  'precpu_stats': instance.precpuStats?.toJson(),
};

ContainerBlkioStats _$ContainerBlkioStatsFromJson(Map<String, dynamic> json) =>
    ContainerBlkioStats(
      ioServiceBytesRecursive:
          (json['io_service_bytes_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      ioServicedRecursive:
          (json['io_serviced_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      ioQueueRecursive:
          (json['io_queue_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      ioServiceTimeRecursive:
          (json['io_service_time_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      ioWaitTimeRecursive:
          (json['io_wait_time_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      ioMergedRecursive:
          (json['io_merged_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      ioTimeRecursive:
          (json['io_time_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      sectorsRecursive:
          (json['sectors_recursive'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ContainerBlkioStatEntry.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$ContainerBlkioStatsToJson(
  ContainerBlkioStats instance,
) => <String, dynamic>{
  'io_service_bytes_recursive': instance.ioServiceBytesRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'io_serviced_recursive': instance.ioServicedRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'io_queue_recursive': instance.ioQueueRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'io_service_time_recursive': instance.ioServiceTimeRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'io_wait_time_recursive': instance.ioWaitTimeRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'io_merged_recursive': instance.ioMergedRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'io_time_recursive': instance.ioTimeRecursive
      ?.map((e) => e.toJson())
      .toList(),
  'sectors_recursive': instance.sectorsRecursive
      ?.map((e) => e.toJson())
      .toList(),
};

ContainerBlkioStatEntry _$ContainerBlkioStatEntryFromJson(
  Map<String, dynamic> json,
) => ContainerBlkioStatEntry(
  major: (json['major'] as num?)?.toInt(),
  minor: (json['minor'] as num?)?.toInt(),
  op: json['op'] as String?,
  $value: (json['value'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContainerBlkioStatEntryToJson(
  ContainerBlkioStatEntry instance,
) => <String, dynamic>{
  'major': instance.major,
  'minor': instance.minor,
  'op': instance.op,
  'value': instance.$value,
};

ContainerCPUStats _$ContainerCPUStatsFromJson(Map<String, dynamic> json) =>
    ContainerCPUStats(
      cpuUsage: json['cpu_usage'] == null
          ? null
          : ContainerCPUUsage.fromJson(
              json['cpu_usage'] as Map<String, dynamic>,
            ),
      systemCpuUsage: (json['system_cpu_usage'] as num?)?.toInt(),
      onlineCpus: (json['online_cpus'] as num?)?.toInt(),
      throttlingData: json['throttling_data'] == null
          ? null
          : ContainerThrottlingData.fromJson(
              json['throttling_data'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ContainerCPUStatsToJson(ContainerCPUStats instance) =>
    <String, dynamic>{
      'cpu_usage': instance.cpuUsage?.toJson(),
      'system_cpu_usage': instance.systemCpuUsage,
      'online_cpus': instance.onlineCpus,
      'throttling_data': instance.throttlingData?.toJson(),
    };

ContainerCPUUsage _$ContainerCPUUsageFromJson(Map<String, dynamic> json) =>
    ContainerCPUUsage(
      totalUsage: (json['total_usage'] as num?)?.toInt(),
      percpuUsage:
          (json['percpu_usage'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      usageInKernelmode: (json['usage_in_kernelmode'] as num?)?.toInt(),
      usageInUsermode: (json['usage_in_usermode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContainerCPUUsageToJson(ContainerCPUUsage instance) =>
    <String, dynamic>{
      'total_usage': instance.totalUsage,
      'percpu_usage': instance.percpuUsage,
      'usage_in_kernelmode': instance.usageInKernelmode,
      'usage_in_usermode': instance.usageInUsermode,
    };

ContainerPidsStats _$ContainerPidsStatsFromJson(Map<String, dynamic> json) =>
    ContainerPidsStats(
      current: (json['current'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContainerPidsStatsToJson(ContainerPidsStats instance) =>
    <String, dynamic>{'current': instance.current, 'limit': instance.limit};

ContainerThrottlingData _$ContainerThrottlingDataFromJson(
  Map<String, dynamic> json,
) => ContainerThrottlingData(
  periods: (json['periods'] as num?)?.toInt(),
  throttledPeriods: (json['throttled_periods'] as num?)?.toInt(),
  throttledTime: (json['throttled_time'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContainerThrottlingDataToJson(
  ContainerThrottlingData instance,
) => <String, dynamic>{
  'periods': instance.periods,
  'throttled_periods': instance.throttledPeriods,
  'throttled_time': instance.throttledTime,
};

ContainerMemoryStats _$ContainerMemoryStatsFromJson(
  Map<String, dynamic> json,
) => ContainerMemoryStats(
  usage: (json['usage'] as num?)?.toInt(),
  maxUsage: (json['max_usage'] as num?)?.toInt(),
  stats: json['stats'] as Map<String, dynamic>?,
  failcnt: (json['failcnt'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  commitbytes: (json['commitbytes'] as num?)?.toInt(),
  commitpeakbytes: (json['commitpeakbytes'] as num?)?.toInt(),
  privateworkingset: (json['privateworkingset'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContainerMemoryStatsToJson(
  ContainerMemoryStats instance,
) => <String, dynamic>{
  'usage': instance.usage,
  'max_usage': instance.maxUsage,
  'stats': instance.stats,
  'failcnt': instance.failcnt,
  'limit': instance.limit,
  'commitbytes': instance.commitbytes,
  'commitpeakbytes': instance.commitpeakbytes,
  'privateworkingset': instance.privateworkingset,
};

ContainerNetworkStats _$ContainerNetworkStatsFromJson(
  Map<String, dynamic> json,
) => ContainerNetworkStats(
  rxBytes: (json['rx_bytes'] as num?)?.toInt(),
  rxPackets: (json['rx_packets'] as num?)?.toInt(),
  rxErrors: (json['rx_errors'] as num?)?.toInt(),
  rxDropped: (json['rx_dropped'] as num?)?.toInt(),
  txBytes: (json['tx_bytes'] as num?)?.toInt(),
  txPackets: (json['tx_packets'] as num?)?.toInt(),
  txErrors: (json['tx_errors'] as num?)?.toInt(),
  txDropped: (json['tx_dropped'] as num?)?.toInt(),
  endpointId: json['endpoint_id'] as String?,
  instanceId: json['instance_id'] as String?,
);

Map<String, dynamic> _$ContainerNetworkStatsToJson(
  ContainerNetworkStats instance,
) => <String, dynamic>{
  'rx_bytes': instance.rxBytes,
  'rx_packets': instance.rxPackets,
  'rx_errors': instance.rxErrors,
  'rx_dropped': instance.rxDropped,
  'tx_bytes': instance.txBytes,
  'tx_packets': instance.txPackets,
  'tx_errors': instance.txErrors,
  'tx_dropped': instance.txDropped,
  'endpoint_id': instance.endpointId,
  'instance_id': instance.instanceId,
};

ContainerStorageStats _$ContainerStorageStatsFromJson(
  Map<String, dynamic> json,
) => ContainerStorageStats(
  readCountNormalized: (json['read_count_normalized'] as num?)?.toInt(),
  readSizeBytes: (json['read_size_bytes'] as num?)?.toInt(),
  writeCountNormalized: (json['write_count_normalized'] as num?)?.toInt(),
  writeSizeBytes: (json['write_size_bytes'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContainerStorageStatsToJson(
  ContainerStorageStats instance,
) => <String, dynamic>{
  'read_count_normalized': instance.readCountNormalized,
  'read_size_bytes': instance.readSizeBytes,
  'write_count_normalized': instance.writeCountNormalized,
  'write_size_bytes': instance.writeSizeBytes,
};

ContainerTopResponse _$ContainerTopResponseFromJson(
  Map<String, dynamic> json,
) => ContainerTopResponse(
  titles:
      (json['Titles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  processes:
      (json['Processes'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
          .toList() ??
      [],
);

Map<String, dynamic> _$ContainerTopResponseToJson(
  ContainerTopResponse instance,
) => <String, dynamic>{
  'Titles': instance.titles,
  'Processes': instance.processes,
};

ContainerWaitResponse _$ContainerWaitResponseFromJson(
  Map<String, dynamic> json,
) => ContainerWaitResponse(
  statusCode: (json['StatusCode'] as num).toInt(),
  error: json['Error'] == null
      ? null
      : ContainerWaitExitError.fromJson(json['Error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContainerWaitResponseToJson(
  ContainerWaitResponse instance,
) => <String, dynamic>{
  'StatusCode': instance.statusCode,
  'Error': instance.error?.toJson(),
};

ContainerWaitExitError _$ContainerWaitExitErrorFromJson(
  Map<String, dynamic> json,
) => ContainerWaitExitError(message: json['Message'] as String?);

Map<String, dynamic> _$ContainerWaitExitErrorToJson(
  ContainerWaitExitError instance,
) => <String, dynamic>{'Message': instance.message};

SystemVersion _$SystemVersionFromJson(Map<String, dynamic> json) =>
    SystemVersion(
      platform: json['Platform'] == null
          ? null
          : SystemVersion$Platform.fromJson(
              json['Platform'] as Map<String, dynamic>,
            ),
      components: (json['Components'] as List<dynamic>?)
          ?.map(
            (e) => SystemVersion$Components$Item.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      version: json['Version'] as String?,
      apiVersion: json['ApiVersion'] as String?,
      minAPIVersion: json['MinAPIVersion'] as String?,
      gitCommit: json['GitCommit'] as String?,
      goVersion: json['GoVersion'] as String?,
      os: json['Os'] as String?,
      arch: json['Arch'] as String?,
      kernelVersion: json['KernelVersion'] as String?,
      experimental: json['Experimental'] as bool?,
      buildTime: json['BuildTime'] as String?,
    );

Map<String, dynamic> _$SystemVersionToJson(SystemVersion instance) =>
    <String, dynamic>{
      'Platform': instance.platform?.toJson(),
      'Components': instance.components?.map((e) => e.toJson()).toList(),
      'Version': instance.version,
      'ApiVersion': instance.apiVersion,
      'MinAPIVersion': instance.minAPIVersion,
      'GitCommit': instance.gitCommit,
      'GoVersion': instance.goVersion,
      'Os': instance.os,
      'Arch': instance.arch,
      'KernelVersion': instance.kernelVersion,
      'Experimental': instance.experimental,
      'BuildTime': instance.buildTime,
    };

SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) => SystemInfo(
  id: json['ID'] as String?,
  containers: (json['Containers'] as num?)?.toInt(),
  containersRunning: (json['ContainersRunning'] as num?)?.toInt(),
  containersPaused: (json['ContainersPaused'] as num?)?.toInt(),
  containersStopped: (json['ContainersStopped'] as num?)?.toInt(),
  images: (json['Images'] as num?)?.toInt(),
  driver: json['Driver'] as String?,
  driverStatus:
      (json['DriverStatus'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
          .toList() ??
      [],
  dockerRootDir: json['DockerRootDir'] as String?,
  plugins: json['Plugins'] == null
      ? null
      : PluginsInfo.fromJson(json['Plugins'] as Map<String, dynamic>),
  memoryLimit: json['MemoryLimit'] as bool?,
  swapLimit: json['SwapLimit'] as bool?,
  cpuCfsPeriod: json['CpuCfsPeriod'] as bool?,
  cpuCfsQuota: json['CpuCfsQuota'] as bool?,
  cPUShares: json['CPUShares'] as bool?,
  cPUSet: json['CPUSet'] as bool?,
  pidsLimit: json['PidsLimit'] as bool?,
  oomKillDisable: json['OomKillDisable'] as bool?,
  iPv4Forwarding: json['IPv4Forwarding'] as bool?,
  debug: json['Debug'] as bool?,
  nFd: (json['NFd'] as num?)?.toInt(),
  nGoroutines: (json['NGoroutines'] as num?)?.toInt(),
  systemTime: json['SystemTime'] as String?,
  loggingDriver: json['LoggingDriver'] as String?,
  cgroupDriver: SystemInfo.systemInfoCgroupDriverCgroupDriverNullableFromJson(
    json['CgroupDriver'],
  ),
  cgroupVersion:
      SystemInfo.systemInfoCgroupVersionCgroupVersionNullableFromJson(
        json['CgroupVersion'],
      ),
  nEventsListener: (json['NEventsListener'] as num?)?.toInt(),
  kernelVersion: json['KernelVersion'] as String?,
  operatingSystem: json['OperatingSystem'] as String?,
  oSVersion: json['OSVersion'] as String?,
  oSType: json['OSType'] as String?,
  architecture: json['Architecture'] as String?,
  ncpu: (json['NCPU'] as num?)?.toInt(),
  memTotal: (json['MemTotal'] as num?)?.toInt(),
  indexServerAddress: json['IndexServerAddress'] as String?,
  registryConfig: json['RegistryConfig'] == null
      ? null
      : RegistryServiceConfig.fromJson(
          json['RegistryConfig'] as Map<String, dynamic>,
        ),
  genericResources: (json['GenericResources'] as List<dynamic>?)
      ?.map((e) => GenericResources$Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  httpProxy: json['HttpProxy'] as String?,
  httpsProxy: json['HttpsProxy'] as String?,
  noProxy: json['NoProxy'] as String?,
  name: json['Name'] as String?,
  labels:
      (json['Labels'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  experimentalBuild: json['ExperimentalBuild'] as bool?,
  serverVersion: json['ServerVersion'] as String?,
  runtimes: json['Runtimes'] as Map<String, dynamic>?,
  defaultRuntime: json['DefaultRuntime'] as String?,
  swarm: json['Swarm'] == null
      ? null
      : SwarmInfo.fromJson(json['Swarm'] as Map<String, dynamic>),
  liveRestoreEnabled: json['LiveRestoreEnabled'] as bool? ?? false,
  isolation: SystemInfo.systemInfoIsolationIsolationNullableFromJson(
    json['Isolation'],
  ),
  initBinary: json['InitBinary'] as String?,
  containerdCommit: json['ContainerdCommit'] == null
      ? null
      : Commit.fromJson(json['ContainerdCommit'] as Map<String, dynamic>),
  runcCommit: json['RuncCommit'] == null
      ? null
      : Commit.fromJson(json['RuncCommit'] as Map<String, dynamic>),
  initCommit: json['InitCommit'] == null
      ? null
      : Commit.fromJson(json['InitCommit'] as Map<String, dynamic>),
  securityOptions:
      (json['SecurityOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  productLicense: json['ProductLicense'] as String?,
  defaultAddressPools: (json['DefaultAddressPools'] as List<dynamic>?)
      ?.map(
        (e) => SystemInfo$DefaultAddressPools$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  firewallBackend: json['FirewallBackend'] == null
      ? null
      : FirewallInfo.fromJson(json['FirewallBackend'] as Map<String, dynamic>),
  discoveredDevices:
      (json['DiscoveredDevices'] as List<dynamic>?)
          ?.map((e) => DeviceInfo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  nri: json['NRI'] == null
      ? null
      : NRIInfo.fromJson(json['NRI'] as Map<String, dynamic>),
  warnings:
      (json['Warnings'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  cDISpecDirs:
      (json['CDISpecDirs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  containerd: json['Containerd'] == null
      ? null
      : ContainerdInfo.fromJson(json['Containerd'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SystemInfoToJson(
  SystemInfo instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Containers': instance.containers,
  'ContainersRunning': instance.containersRunning,
  'ContainersPaused': instance.containersPaused,
  'ContainersStopped': instance.containersStopped,
  'Images': instance.images,
  'Driver': instance.driver,
  'DriverStatus': instance.driverStatus,
  'DockerRootDir': instance.dockerRootDir,
  'Plugins': instance.plugins?.toJson(),
  'MemoryLimit': instance.memoryLimit,
  'SwapLimit': instance.swapLimit,
  'CpuCfsPeriod': instance.cpuCfsPeriod,
  'CpuCfsQuota': instance.cpuCfsQuota,
  'CPUShares': instance.cPUShares,
  'CPUSet': instance.cPUSet,
  'PidsLimit': instance.pidsLimit,
  'OomKillDisable': instance.oomKillDisable,
  'IPv4Forwarding': instance.iPv4Forwarding,
  'Debug': instance.debug,
  'NFd': instance.nFd,
  'NGoroutines': instance.nGoroutines,
  'SystemTime': instance.systemTime,
  'LoggingDriver': instance.loggingDriver,
  'CgroupDriver': systemInfoCgroupDriverNullableToJson(instance.cgroupDriver),
  'CgroupVersion': systemInfoCgroupVersionNullableToJson(
    instance.cgroupVersion,
  ),
  'NEventsListener': instance.nEventsListener,
  'KernelVersion': instance.kernelVersion,
  'OperatingSystem': instance.operatingSystem,
  'OSVersion': instance.oSVersion,
  'OSType': instance.oSType,
  'Architecture': instance.architecture,
  'NCPU': instance.ncpu,
  'MemTotal': instance.memTotal,
  'IndexServerAddress': instance.indexServerAddress,
  'RegistryConfig': instance.registryConfig?.toJson(),
  'GenericResources': instance.genericResources
      ?.map((e) => e.toJson())
      .toList(),
  'HttpProxy': instance.httpProxy,
  'HttpsProxy': instance.httpsProxy,
  'NoProxy': instance.noProxy,
  'Name': instance.name,
  'Labels': instance.labels,
  'ExperimentalBuild': instance.experimentalBuild,
  'ServerVersion': instance.serverVersion,
  'Runtimes': instance.runtimes,
  'DefaultRuntime': instance.defaultRuntime,
  'Swarm': instance.swarm?.toJson(),
  'LiveRestoreEnabled': instance.liveRestoreEnabled,
  'Isolation': systemInfoIsolationNullableToJson(instance.isolation),
  'InitBinary': instance.initBinary,
  'ContainerdCommit': instance.containerdCommit?.toJson(),
  'RuncCommit': instance.runcCommit?.toJson(),
  'InitCommit': instance.initCommit?.toJson(),
  'SecurityOptions': instance.securityOptions,
  'ProductLicense': instance.productLicense,
  'DefaultAddressPools': instance.defaultAddressPools
      ?.map((e) => e.toJson())
      .toList(),
  'FirewallBackend': instance.firewallBackend?.toJson(),
  'DiscoveredDevices': instance.discoveredDevices
      ?.map((e) => e.toJson())
      .toList(),
  'NRI': instance.nri?.toJson(),
  'Warnings': instance.warnings,
  'CDISpecDirs': instance.cDISpecDirs,
  'Containerd': instance.containerd?.toJson(),
};

ContainerdInfo _$ContainerdInfoFromJson(Map<String, dynamic> json) =>
    ContainerdInfo(
      address: json['Address'] as String?,
      namespaces: json['Namespaces'] == null
          ? null
          : ContainerdInfo$Namespaces.fromJson(
              json['Namespaces'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ContainerdInfoToJson(ContainerdInfo instance) =>
    <String, dynamic>{
      'Address': instance.address,
      'Namespaces': instance.namespaces?.toJson(),
    };

FirewallInfo _$FirewallInfoFromJson(Map<String, dynamic> json) => FirewallInfo(
  driver: json['Driver'] as String?,
  info:
      (json['Info'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).map((e) => e as String?).toList())
          .toList() ??
      [],
);

Map<String, dynamic> _$FirewallInfoToJson(FirewallInfo instance) =>
    <String, dynamic>{'Driver': instance.driver, 'Info': instance.info};

PluginsInfo _$PluginsInfoFromJson(Map<String, dynamic> json) => PluginsInfo(
  volume:
      (json['Volume'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  network:
      (json['Network'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  authorization:
      (json['Authorization'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  log: (json['Log'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
);

Map<String, dynamic> _$PluginsInfoToJson(PluginsInfo instance) =>
    <String, dynamic>{
      'Volume': instance.volume,
      'Network': instance.network,
      'Authorization': instance.authorization,
      'Log': instance.log,
    };

RegistryServiceConfig _$RegistryServiceConfigFromJson(
  Map<String, dynamic> json,
) => RegistryServiceConfig(
  insecureRegistryCIDRs:
      (json['InsecureRegistryCIDRs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  indexConfigs: json['IndexConfigs'] as Map<String, dynamic>?,
  mirrors:
      (json['Mirrors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$RegistryServiceConfigToJson(
  RegistryServiceConfig instance,
) => <String, dynamic>{
  'InsecureRegistryCIDRs': instance.insecureRegistryCIDRs,
  'IndexConfigs': instance.indexConfigs,
  'Mirrors': instance.mirrors,
};

IndexInfo _$IndexInfoFromJson(Map<String, dynamic> json) => IndexInfo(
  name: json['Name'] as String?,
  mirrors:
      (json['Mirrors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  secure: json['Secure'] as bool?,
  official: json['Official'] as bool?,
);

Map<String, dynamic> _$IndexInfoToJson(IndexInfo instance) => <String, dynamic>{
  'Name': instance.name,
  'Mirrors': instance.mirrors,
  'Secure': instance.secure,
  'Official': instance.official,
};

Runtime _$RuntimeFromJson(Map<String, dynamic> json) => Runtime(
  path: json['path'] as String?,
  runtimeArgs:
      (json['runtimeArgs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  status: json['status'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$RuntimeToJson(Runtime instance) => <String, dynamic>{
  'path': instance.path,
  'runtimeArgs': instance.runtimeArgs,
  'status': instance.status,
};

Commit _$CommitFromJson(Map<String, dynamic> json) =>
    Commit(id: json['ID'] as String?);

Map<String, dynamic> _$CommitToJson(Commit instance) => <String, dynamic>{
  'ID': instance.id,
};

SwarmInfo _$SwarmInfoFromJson(Map<String, dynamic> json) => SwarmInfo(
  nodeID: json['NodeID'] as String?,
  nodeAddr: json['NodeAddr'] as String?,
  localNodeState: localNodeStateNullableFromJson(json['LocalNodeState']),
  controlAvailable: json['ControlAvailable'] as bool? ?? false,
  error: json['Error'] as String?,
  remoteManagers:
      (json['RemoteManagers'] as List<dynamic>?)
          ?.map((e) => PeerNode.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  nodes: (json['Nodes'] as num?)?.toInt(),
  managers: (json['Managers'] as num?)?.toInt(),
  cluster: json['Cluster'] == null
      ? null
      : ClusterInfo.fromJson(json['Cluster'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SwarmInfoToJson(SwarmInfo instance) => <String, dynamic>{
  'NodeID': instance.nodeID,
  'NodeAddr': instance.nodeAddr,
  'LocalNodeState': localNodeStateNullableToJson(instance.localNodeState),
  'ControlAvailable': instance.controlAvailable,
  'Error': instance.error,
  'RemoteManagers': instance.remoteManagers?.map((e) => e.toJson()).toList(),
  'Nodes': instance.nodes,
  'Managers': instance.managers,
  'Cluster': instance.cluster?.toJson(),
};

PeerNode _$PeerNodeFromJson(Map<String, dynamic> json) =>
    PeerNode(nodeID: json['NodeID'] as String?, addr: json['Addr'] as String?);

Map<String, dynamic> _$PeerNodeToJson(PeerNode instance) => <String, dynamic>{
  'NodeID': instance.nodeID,
  'Addr': instance.addr,
};

NetworkAttachmentConfig _$NetworkAttachmentConfigFromJson(
  Map<String, dynamic> json,
) => NetworkAttachmentConfig(
  target: json['Target'] as String?,
  aliases:
      (json['Aliases'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  driverOpts: json['DriverOpts'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$NetworkAttachmentConfigToJson(
  NetworkAttachmentConfig instance,
) => <String, dynamic>{
  'Target': instance.target,
  'Aliases': instance.aliases,
  'DriverOpts': instance.driverOpts,
};

EventActor _$EventActorFromJson(Map<String, dynamic> json) => EventActor(
  id: json['ID'] as String?,
  attributes: json['Attributes'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$EventActorToJson(EventActor instance) =>
    <String, dynamic>{'ID': instance.id, 'Attributes': instance.attributes};

EventMessage _$EventMessageFromJson(Map<String, dynamic> json) => EventMessage(
  type: eventMessageTypeNullableFromJson(json['Type']),
  action: json['Action'] as String?,
  actor: json['Actor'] == null
      ? null
      : EventActor.fromJson(json['Actor'] as Map<String, dynamic>),
  scope: eventMessageScopeNullableFromJson(json['scope']),
  time: (json['time'] as num?)?.toInt(),
  timeNano: (json['timeNano'] as num?)?.toInt(),
);

Map<String, dynamic> _$EventMessageToJson(EventMessage instance) =>
    <String, dynamic>{
      'Type': eventMessageTypeNullableToJson(instance.type),
      'Action': instance.action,
      'Actor': instance.actor?.toJson(),
      'scope': eventMessageScopeNullableToJson(instance.scope),
      'time': instance.time,
      'timeNano': instance.timeNano,
    };

OCIDescriptor _$OCIDescriptorFromJson(Map<String, dynamic> json) =>
    OCIDescriptor(
      mediaType: json['mediaType'] as String?,
      digest: json['digest'] as String?,
      size: (json['size'] as num?)?.toInt(),
      urls:
          (json['urls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      annotations: json['annotations'] as Map<String, dynamic>?,
      data: json['data'] as String?,
      platform: json['platform'] == null
          ? null
          : OCIPlatform.fromJson(json['platform'] as Map<String, dynamic>),
      artifactType: json['artifactType'] as String?,
    );

Map<String, dynamic> _$OCIDescriptorToJson(OCIDescriptor instance) =>
    <String, dynamic>{
      'mediaType': instance.mediaType,
      'digest': instance.digest,
      'size': instance.size,
      'urls': instance.urls,
      'annotations': instance.annotations,
      'data': instance.data,
      'platform': instance.platform?.toJson(),
      'artifactType': instance.artifactType,
    };

OCIPlatform _$OCIPlatformFromJson(Map<String, dynamic> json) => OCIPlatform(
  architecture: json['architecture'] as String?,
  os: json['os'] as String?,
  osVersion: json['os.version'] as String?,
  osFeatures:
      (json['os.features'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  variant: json['variant'] as String?,
);

Map<String, dynamic> _$OCIPlatformToJson(OCIPlatform instance) =>
    <String, dynamic>{
      'architecture': instance.architecture,
      'os': instance.os,
      'os.version': instance.osVersion,
      'os.features': instance.osFeatures,
      'variant': instance.variant,
    };

DistributionInspect _$DistributionInspectFromJson(Map<String, dynamic> json) =>
    DistributionInspect(
      descriptor: OCIDescriptor.fromJson(
        json['Descriptor'] as Map<String, dynamic>,
      ),
      platforms:
          (json['Platforms'] as List<dynamic>?)
              ?.map((e) => OCIPlatform.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DistributionInspectToJson(
  DistributionInspect instance,
) => <String, dynamic>{
  'Descriptor': instance.descriptor.toJson(),
  'Platforms': instance.platforms.map((e) => e.toJson()).toList(),
};

ClusterVolume _$ClusterVolumeFromJson(Map<String, dynamic> json) =>
    ClusterVolume(
      id: json['ID'] as String?,
      version: json['Version'] == null
          ? null
          : ObjectVersion.fromJson(json['Version'] as Map<String, dynamic>),
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
      spec: json['Spec'] == null
          ? null
          : ClusterVolumeSpec.fromJson(json['Spec'] as Map<String, dynamic>),
      info: json['Info'] == null
          ? null
          : ClusterVolume$Info.fromJson(json['Info'] as Map<String, dynamic>),
      publishStatus: (json['PublishStatus'] as List<dynamic>?)
          ?.map(
            (e) => ClusterVolume$PublishStatus$Item.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$ClusterVolumeToJson(ClusterVolume instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'Version': instance.version?.toJson(),
      'CreatedAt': instance.createdAt,
      'UpdatedAt': instance.updatedAt,
      'Spec': instance.spec?.toJson(),
      'Info': instance.info?.toJson(),
      'PublishStatus': instance.publishStatus?.map((e) => e.toJson()).toList(),
    };

ClusterVolumeSpec _$ClusterVolumeSpecFromJson(Map<String, dynamic> json) =>
    ClusterVolumeSpec(
      group: json['Group'] as String?,
      accessMode: json['AccessMode'] == null
          ? null
          : ClusterVolumeSpec$AccessMode.fromJson(
              json['AccessMode'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ClusterVolumeSpecToJson(ClusterVolumeSpec instance) =>
    <String, dynamic>{
      'Group': instance.group,
      'AccessMode': instance.accessMode?.toJson(),
    };

Topology _$TopologyFromJson(Map<String, dynamic> json) =>
    Topology(segments: json['Segments'] as Map<String, dynamic>?);

Map<String, dynamic> _$TopologyToJson(Topology instance) => <String, dynamic>{
  'Segments': instance.segments,
};

ImageManifestSummary _$ImageManifestSummaryFromJson(
  Map<String, dynamic> json,
) => ImageManifestSummary(
  id: json['ID'] as String,
  descriptor: OCIDescriptor.fromJson(
    json['Descriptor'] as Map<String, dynamic>,
  ),
  available: json['Available'] as bool,
  size: ImageManifestSummary$Size.fromJson(
    json['Size'] as Map<String, dynamic>,
  ),
  kind: imageManifestSummaryKindFromJson(json['Kind']),
  imageData: json['ImageData'] == null
      ? null
      : ImageManifestSummary$ImageData.fromJson(
          json['ImageData'] as Map<String, dynamic>,
        ),
  attestationData: json['AttestationData'] == null
      ? null
      : ImageManifestSummary$AttestationData.fromJson(
          json['AttestationData'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ImageManifestSummaryToJson(
  ImageManifestSummary instance,
) => <String, dynamic>{
  'ID': instance.id,
  'Descriptor': instance.descriptor.toJson(),
  'Available': instance.available,
  'Size': instance.size.toJson(),
  'Kind': imageManifestSummaryKindToJson(instance.kind),
  'ImageData': instance.imageData?.toJson(),
  'AttestationData': instance.attestationData?.toJson(),
};

ContainersPrunePost$Response _$ContainersPrunePost$ResponseFromJson(
  Map<String, dynamic> json,
) => ContainersPrunePost$Response(
  containersDeleted:
      (json['ContainersDeleted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  spaceReclaimed: (json['SpaceReclaimed'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContainersPrunePost$ResponseToJson(
  ContainersPrunePost$Response instance,
) => <String, dynamic>{
  'ContainersDeleted': instance.containersDeleted,
  'SpaceReclaimed': instance.spaceReclaimed,
};

BuildPrunePost$Response _$BuildPrunePost$ResponseFromJson(
  Map<String, dynamic> json,
) => BuildPrunePost$Response(
  cachesDeleted:
      (json['CachesDeleted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  spaceReclaimed: (json['SpaceReclaimed'] as num?)?.toInt(),
);

Map<String, dynamic> _$BuildPrunePost$ResponseToJson(
  BuildPrunePost$Response instance,
) => <String, dynamic>{
  'CachesDeleted': instance.cachesDeleted,
  'SpaceReclaimed': instance.spaceReclaimed,
};

ImagesSearchGet$Response$Item _$ImagesSearchGet$Response$ItemFromJson(
  Map<String, dynamic> json,
) => ImagesSearchGet$Response$Item(
  description: json['description'] as String?,
  isOfficial: json['is_official'] as bool?,
  isAutomated: json['is_automated'] as bool?,
  name: json['name'] as String?,
  starCount: (json['star_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$ImagesSearchGet$Response$ItemToJson(
  ImagesSearchGet$Response$Item instance,
) => <String, dynamic>{
  'description': instance.description,
  'is_official': instance.isOfficial,
  'is_automated': instance.isAutomated,
  'name': instance.name,
  'star_count': instance.starCount,
};

ImagesPrunePost$Response _$ImagesPrunePost$ResponseFromJson(
  Map<String, dynamic> json,
) => ImagesPrunePost$Response(
  imagesDeleted:
      (json['ImagesDeleted'] as List<dynamic>?)
          ?.map(
            (e) => ImageDeleteResponseItem.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  spaceReclaimed: (json['SpaceReclaimed'] as num?)?.toInt(),
);

Map<String, dynamic> _$ImagesPrunePost$ResponseToJson(
  ImagesPrunePost$Response instance,
) => <String, dynamic>{
  'ImagesDeleted': instance.imagesDeleted?.map((e) => e.toJson()).toList(),
  'SpaceReclaimed': instance.spaceReclaimed,
};

SystemDfGet$Response _$SystemDfGet$ResponseFromJson(
  Map<String, dynamic> json,
) => SystemDfGet$Response(
  imageUsage: json['ImageUsage'] == null
      ? null
      : ImagesDiskUsage.fromJson(json['ImageUsage'] as Map<String, dynamic>),
  containerUsage: json['ContainerUsage'] == null
      ? null
      : ContainersDiskUsage.fromJson(
          json['ContainerUsage'] as Map<String, dynamic>,
        ),
  volumeUsage: json['VolumeUsage'] == null
      ? null
      : VolumesDiskUsage.fromJson(json['VolumeUsage'] as Map<String, dynamic>),
  buildCacheUsage: json['BuildCacheUsage'] == null
      ? null
      : BuildCacheDiskUsage.fromJson(
          json['BuildCacheUsage'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SystemDfGet$ResponseToJson(
  SystemDfGet$Response instance,
) => <String, dynamic>{
  'ImageUsage': instance.imageUsage?.toJson(),
  'ContainerUsage': instance.containerUsage?.toJson(),
  'VolumeUsage': instance.volumeUsage?.toJson(),
  'BuildCacheUsage': instance.buildCacheUsage?.toJson(),
};

ExecIdJsonGet$Response _$ExecIdJsonGet$ResponseFromJson(
  Map<String, dynamic> json,
) => ExecIdJsonGet$Response(
  canRemove: json['CanRemove'] as bool?,
  detachKeys: json['DetachKeys'] as String?,
  id: json['ID'] as String?,
  running: json['Running'] as bool?,
  exitCode: (json['ExitCode'] as num?)?.toInt(),
  processConfig: json['ProcessConfig'] == null
      ? null
      : ProcessConfig.fromJson(json['ProcessConfig'] as Map<String, dynamic>),
  openStdin: json['OpenStdin'] as bool?,
  openStderr: json['OpenStderr'] as bool?,
  openStdout: json['OpenStdout'] as bool?,
  containerID: json['ContainerID'] as String?,
  pid: (json['Pid'] as num?)?.toInt(),
);

Map<String, dynamic> _$ExecIdJsonGet$ResponseToJson(
  ExecIdJsonGet$Response instance,
) => <String, dynamic>{
  'CanRemove': instance.canRemove,
  'DetachKeys': instance.detachKeys,
  'ID': instance.id,
  'Running': instance.running,
  'ExitCode': instance.exitCode,
  'ProcessConfig': instance.processConfig?.toJson(),
  'OpenStdin': instance.openStdin,
  'OpenStderr': instance.openStderr,
  'OpenStdout': instance.openStdout,
  'ContainerID': instance.containerID,
  'Pid': instance.pid,
};

VolumesPrunePost$Response _$VolumesPrunePost$ResponseFromJson(
  Map<String, dynamic> json,
) => VolumesPrunePost$Response(
  volumesDeleted:
      (json['VolumesDeleted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  spaceReclaimed: (json['SpaceReclaimed'] as num?)?.toInt(),
);

Map<String, dynamic> _$VolumesPrunePost$ResponseToJson(
  VolumesPrunePost$Response instance,
) => <String, dynamic>{
  'VolumesDeleted': instance.volumesDeleted,
  'SpaceReclaimed': instance.spaceReclaimed,
};

NetworksPrunePost$Response _$NetworksPrunePost$ResponseFromJson(
  Map<String, dynamic> json,
) => NetworksPrunePost$Response(
  networksDeleted:
      (json['NetworksDeleted'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$NetworksPrunePost$ResponseToJson(
  NetworksPrunePost$Response instance,
) => <String, dynamic>{'NetworksDeleted': instance.networksDeleted};

SwarmUnlockkeyGet$Response _$SwarmUnlockkeyGet$ResponseFromJson(
  Map<String, dynamic> json,
) => SwarmUnlockkeyGet$Response(unlockKey: json['UnlockKey'] as String?);

Map<String, dynamic> _$SwarmUnlockkeyGet$ResponseToJson(
  SwarmUnlockkeyGet$Response instance,
) => <String, dynamic>{'UnlockKey': instance.unlockKey};

Mount$BindOptions _$Mount$BindOptionsFromJson(Map<String, dynamic> json) =>
    Mount$BindOptions(
      propagation: mount$BindOptionsPropagationNullableFromJson(
        json['Propagation'],
      ),
      nonRecursive: json['NonRecursive'] as bool? ?? false,
      createMountpoint: json['CreateMountpoint'] as bool? ?? false,
      readOnlyNonRecursive: json['ReadOnlyNonRecursive'] as bool? ?? false,
      readOnlyForceRecursive: json['ReadOnlyForceRecursive'] as bool? ?? false,
    );

Map<String, dynamic> _$Mount$BindOptionsToJson(Mount$BindOptions instance) =>
    <String, dynamic>{
      'Propagation': mount$BindOptionsPropagationNullableToJson(
        instance.propagation,
      ),
      'NonRecursive': instance.nonRecursive,
      'CreateMountpoint': instance.createMountpoint,
      'ReadOnlyNonRecursive': instance.readOnlyNonRecursive,
      'ReadOnlyForceRecursive': instance.readOnlyForceRecursive,
    };

Mount$VolumeOptions _$Mount$VolumeOptionsFromJson(Map<String, dynamic> json) =>
    Mount$VolumeOptions(
      noCopy: json['NoCopy'] as bool? ?? false,
      labels: json['Labels'] as Map<String, dynamic>?,
      driverConfig: json['DriverConfig'] == null
          ? null
          : Mount$VolumeOptions$DriverConfig.fromJson(
              json['DriverConfig'] as Map<String, dynamic>,
            ),
      subpath: json['Subpath'] as String?,
    );

Map<String, dynamic> _$Mount$VolumeOptionsToJson(
  Mount$VolumeOptions instance,
) => <String, dynamic>{
  'NoCopy': instance.noCopy,
  'Labels': instance.labels,
  'DriverConfig': instance.driverConfig?.toJson(),
  'Subpath': instance.subpath,
};

Mount$ImageOptions _$Mount$ImageOptionsFromJson(Map<String, dynamic> json) =>
    Mount$ImageOptions(subpath: json['Subpath'] as String?);

Map<String, dynamic> _$Mount$ImageOptionsToJson(Mount$ImageOptions instance) =>
    <String, dynamic>{'Subpath': instance.subpath};

Mount$TmpfsOptions _$Mount$TmpfsOptionsFromJson(Map<String, dynamic> json) =>
    Mount$TmpfsOptions(
      sizeBytes: (json['SizeBytes'] as num?)?.toInt(),
      mode: (json['Mode'] as num?)?.toInt(),
      options:
          (json['Options'] as List<dynamic>?)
              ?.map(
                (e) => (e as List<dynamic>).map((e) => e as String?).toList(),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$Mount$TmpfsOptionsToJson(Mount$TmpfsOptions instance) =>
    <String, dynamic>{
      'SizeBytes': instance.sizeBytes,
      'Mode': instance.mode,
      'Options': instance.options,
    };

Resources$BlkioWeightDevice$Item _$Resources$BlkioWeightDevice$ItemFromJson(
  Map<String, dynamic> json,
) => Resources$BlkioWeightDevice$Item(
  path: json['Path'] as String?,
  weight: (json['Weight'] as num?)?.toInt(),
);

Map<String, dynamic> _$Resources$BlkioWeightDevice$ItemToJson(
  Resources$BlkioWeightDevice$Item instance,
) => <String, dynamic>{'Path': instance.path, 'Weight': instance.weight};

Resources$Ulimits$Item _$Resources$Ulimits$ItemFromJson(
  Map<String, dynamic> json,
) => Resources$Ulimits$Item(
  name: json['Name'] as String?,
  soft: (json['Soft'] as num?)?.toInt(),
  hard: (json['Hard'] as num?)?.toInt(),
);

Map<String, dynamic> _$Resources$Ulimits$ItemToJson(
  Resources$Ulimits$Item instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Soft': instance.soft,
  'Hard': instance.hard,
};

GenericResources$Item$NamedResourceSpec
_$GenericResources$Item$NamedResourceSpecFromJson(Map<String, dynamic> json) =>
    GenericResources$Item$NamedResourceSpec(
      kind: json['Kind'] as String?,
      $Value: json['Value'] as String?,
    );

Map<String, dynamic> _$GenericResources$Item$NamedResourceSpecToJson(
  GenericResources$Item$NamedResourceSpec instance,
) => <String, dynamic>{'Kind': instance.kind, 'Value': instance.$Value};

GenericResources$Item$DiscreteResourceSpec
_$GenericResources$Item$DiscreteResourceSpecFromJson(
  Map<String, dynamic> json,
) => GenericResources$Item$DiscreteResourceSpec(
  kind: json['Kind'] as String?,
  $Value: (json['Value'] as num?)?.toInt(),
);

Map<String, dynamic> _$GenericResources$Item$DiscreteResourceSpecToJson(
  GenericResources$Item$DiscreteResourceSpec instance,
) => <String, dynamic>{'Kind': instance.kind, 'Value': instance.$Value};

HostConfig$BlkioWeightDevice$Item _$HostConfig$BlkioWeightDevice$ItemFromJson(
  Map<String, dynamic> json,
) => HostConfig$BlkioWeightDevice$Item(
  path: json['Path'] as String?,
  weight: (json['Weight'] as num?)?.toInt(),
);

Map<String, dynamic> _$HostConfig$BlkioWeightDevice$ItemToJson(
  HostConfig$BlkioWeightDevice$Item instance,
) => <String, dynamic>{'Path': instance.path, 'Weight': instance.weight};

HostConfig$Ulimits$Item _$HostConfig$Ulimits$ItemFromJson(
  Map<String, dynamic> json,
) => HostConfig$Ulimits$Item(
  name: json['Name'] as String?,
  soft: (json['Soft'] as num?)?.toInt(),
  hard: (json['Hard'] as num?)?.toInt(),
);

Map<String, dynamic> _$HostConfig$Ulimits$ItemToJson(
  HostConfig$Ulimits$Item instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Soft': instance.soft,
  'Hard': instance.hard,
};

HostConfig$LogConfig _$HostConfig$LogConfigFromJson(
  Map<String, dynamic> json,
) => HostConfig$LogConfig(
  type: hostConfig$LogConfigTypeNullableFromJson(json['Type']),
  config: json['Config'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$HostConfig$LogConfigToJson(
  HostConfig$LogConfig instance,
) => <String, dynamic>{
  'Type': hostConfig$LogConfigTypeNullableToJson(instance.type),
  'Config': instance.config,
};

ImageInspect$RootFS _$ImageInspect$RootFSFromJson(Map<String, dynamic> json) =>
    ImageInspect$RootFS(
      type: json['Type'] as String,
      layers:
          (json['Layers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ImageInspect$RootFSToJson(
  ImageInspect$RootFS instance,
) => <String, dynamic>{'Type': instance.type, 'Layers': instance.layers};

ImageInspect$Metadata _$ImageInspect$MetadataFromJson(
  Map<String, dynamic> json,
) => ImageInspect$Metadata(lastTagTime: json['LastTagTime'] as String?);

Map<String, dynamic> _$ImageInspect$MetadataToJson(
  ImageInspect$Metadata instance,
) => <String, dynamic>{'LastTagTime': instance.lastTagTime};

Volume$UsageData _$Volume$UsageDataFromJson(Map<String, dynamic> json) =>
    Volume$UsageData(
      size: (json['Size'] as num).toInt(),
      refCount: (json['RefCount'] as num).toInt(),
    );

Map<String, dynamic> _$Volume$UsageDataToJson(Volume$UsageData instance) =>
    <String, dynamic>{'Size': instance.size, 'RefCount': instance.refCount};

Plugin$Settings _$Plugin$SettingsFromJson(
  Map<String, dynamic> json,
) => Plugin$Settings(
  mounts:
      (json['Mounts'] as List<dynamic>?)
          ?.map((e) => PluginMount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  env: (json['Env'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  args:
      (json['Args'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  devices:
      (json['Devices'] as List<dynamic>?)
          ?.map((e) => PluginDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$Plugin$SettingsToJson(Plugin$Settings instance) =>
    <String, dynamic>{
      'Mounts': instance.mounts.map((e) => e.toJson()).toList(),
      'Env': instance.env,
      'Args': instance.args,
      'Devices': instance.devices.map((e) => e.toJson()).toList(),
    };

Plugin$Config _$Plugin$ConfigFromJson(
  Map<String, dynamic> json,
) => Plugin$Config(
  description: json['Description'] as String,
  documentation: json['Documentation'] as String,
  interface: Plugin$Config$Interface.fromJson(
    json['Interface'] as Map<String, dynamic>,
  ),
  entrypoint:
      (json['Entrypoint'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  workDir: json['WorkDir'] as String,
  user: json['User'] == null
      ? null
      : Plugin$Config$User.fromJson(json['User'] as Map<String, dynamic>),
  network: Plugin$Config$Network.fromJson(
    json['Network'] as Map<String, dynamic>,
  ),
  linux: Plugin$Config$Linux.fromJson(json['Linux'] as Map<String, dynamic>),
  propagatedMount: json['PropagatedMount'] as String,
  ipcHost: json['IpcHost'] as bool,
  pidHost: json['PidHost'] as bool,
  mounts:
      (json['Mounts'] as List<dynamic>?)
          ?.map((e) => PluginMount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  env:
      (json['Env'] as List<dynamic>?)
          ?.map((e) => PluginEnv.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  args: Plugin$Config$Args.fromJson(json['Args'] as Map<String, dynamic>),
  rootfs: json['rootfs'] == null
      ? null
      : Plugin$Config$Rootfs.fromJson(json['rootfs'] as Map<String, dynamic>),
);

Map<String, dynamic> _$Plugin$ConfigToJson(Plugin$Config instance) =>
    <String, dynamic>{
      'Description': instance.description,
      'Documentation': instance.documentation,
      'Interface': instance.interface.toJson(),
      'Entrypoint': instance.entrypoint,
      'WorkDir': instance.workDir,
      'User': instance.user?.toJson(),
      'Network': instance.network.toJson(),
      'Linux': instance.linux.toJson(),
      'PropagatedMount': instance.propagatedMount,
      'IpcHost': instance.ipcHost,
      'PidHost': instance.pidHost,
      'Mounts': instance.mounts.map((e) => e.toJson()).toList(),
      'Env': instance.env.map((e) => e.toJson()).toList(),
      'Args': instance.args.toJson(),
      'rootfs': instance.rootfs?.toJson(),
    };

EngineDescription$Plugins$Item _$EngineDescription$Plugins$ItemFromJson(
  Map<String, dynamic> json,
) => EngineDescription$Plugins$Item(
  type: json['Type'] as String?,
  name: json['Name'] as String?,
);

Map<String, dynamic> _$EngineDescription$Plugins$ItemToJson(
  EngineDescription$Plugins$Item instance,
) => <String, dynamic>{'Type': instance.type, 'Name': instance.name};

SwarmSpec$Orchestration _$SwarmSpec$OrchestrationFromJson(
  Map<String, dynamic> json,
) => SwarmSpec$Orchestration(
  taskHistoryRetentionLimit: (json['TaskHistoryRetentionLimit'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$SwarmSpec$OrchestrationToJson(
  SwarmSpec$Orchestration instance,
) => <String, dynamic>{
  'TaskHistoryRetentionLimit': instance.taskHistoryRetentionLimit,
};

SwarmSpec$Raft _$SwarmSpec$RaftFromJson(Map<String, dynamic> json) =>
    SwarmSpec$Raft(
      snapshotInterval: (json['SnapshotInterval'] as num?)?.toInt(),
      keepOldSnapshots: (json['KeepOldSnapshots'] as num?)?.toInt(),
      logEntriesForSlowFollowers: (json['LogEntriesForSlowFollowers'] as num?)
          ?.toInt(),
      electionTick: (json['ElectionTick'] as num?)?.toInt(),
      heartbeatTick: (json['HeartbeatTick'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SwarmSpec$RaftToJson(SwarmSpec$Raft instance) =>
    <String, dynamic>{
      'SnapshotInterval': instance.snapshotInterval,
      'KeepOldSnapshots': instance.keepOldSnapshots,
      'LogEntriesForSlowFollowers': instance.logEntriesForSlowFollowers,
      'ElectionTick': instance.electionTick,
      'HeartbeatTick': instance.heartbeatTick,
    };

SwarmSpec$Dispatcher _$SwarmSpec$DispatcherFromJson(
  Map<String, dynamic> json,
) => SwarmSpec$Dispatcher(
  heartbeatPeriod: (json['HeartbeatPeriod'] as num?)?.toInt(),
);

Map<String, dynamic> _$SwarmSpec$DispatcherToJson(
  SwarmSpec$Dispatcher instance,
) => <String, dynamic>{'HeartbeatPeriod': instance.heartbeatPeriod};

SwarmSpec$CAConfig _$SwarmSpec$CAConfigFromJson(Map<String, dynamic> json) =>
    SwarmSpec$CAConfig(
      nodeCertExpiry: (json['NodeCertExpiry'] as num?)?.toInt(),
      externalCAs: (json['ExternalCAs'] as List<dynamic>?)
          ?.map(
            (e) => SwarmSpec$CAConfig$ExternalCAs$Item.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      signingCACert: json['SigningCACert'] as String?,
      signingCAKey: json['SigningCAKey'] as String?,
      forceRotate: (json['ForceRotate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SwarmSpec$CAConfigToJson(SwarmSpec$CAConfig instance) =>
    <String, dynamic>{
      'NodeCertExpiry': instance.nodeCertExpiry,
      'ExternalCAs': instance.externalCAs?.map((e) => e.toJson()).toList(),
      'SigningCACert': instance.signingCACert,
      'SigningCAKey': instance.signingCAKey,
      'ForceRotate': instance.forceRotate,
    };

SwarmSpec$EncryptionConfig _$SwarmSpec$EncryptionConfigFromJson(
  Map<String, dynamic> json,
) => SwarmSpec$EncryptionConfig(
  autoLockManagers: json['AutoLockManagers'] as bool?,
);

Map<String, dynamic> _$SwarmSpec$EncryptionConfigToJson(
  SwarmSpec$EncryptionConfig instance,
) => <String, dynamic>{'AutoLockManagers': instance.autoLockManagers};

SwarmSpec$TaskDefaults _$SwarmSpec$TaskDefaultsFromJson(
  Map<String, dynamic> json,
) => SwarmSpec$TaskDefaults(
  logDriver: json['LogDriver'] == null
      ? null
      : SwarmSpec$TaskDefaults$LogDriver.fromJson(
          json['LogDriver'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$SwarmSpec$TaskDefaultsToJson(
  SwarmSpec$TaskDefaults instance,
) => <String, dynamic>{'LogDriver': instance.logDriver?.toJson()};

TaskSpec$PluginSpec _$TaskSpec$PluginSpecFromJson(Map<String, dynamic> json) =>
    TaskSpec$PluginSpec(
      name: json['Name'] as String?,
      remote: json['Remote'] as String?,
      disabled: json['Disabled'] as bool?,
      pluginPrivilege:
          (json['PluginPrivilege'] as List<dynamic>?)
              ?.map((e) => PluginPrivilege.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TaskSpec$PluginSpecToJson(
  TaskSpec$PluginSpec instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Remote': instance.remote,
  'Disabled': instance.disabled,
  'PluginPrivilege': instance.pluginPrivilege?.map((e) => e.toJson()).toList(),
};

TaskSpec$ContainerSpec _$TaskSpec$ContainerSpecFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec(
  image: json['Image'] as String?,
  labels: json['Labels'] as Map<String, dynamic>?,
  command:
      (json['Command'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  args:
      (json['Args'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  hostname: json['Hostname'] as String?,
  env: (json['Env'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  dir: json['Dir'] as String?,
  user: json['User'] as String?,
  groups:
      (json['Groups'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  privileges: json['Privileges'] == null
      ? null
      : TaskSpec$ContainerSpec$Privileges.fromJson(
          json['Privileges'] as Map<String, dynamic>,
        ),
  tty: json['TTY'] as bool?,
  openStdin: json['OpenStdin'] as bool?,
  readOnly: json['ReadOnly'] as bool?,
  mounts:
      (json['Mounts'] as List<dynamic>?)
          ?.map((e) => Mount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  stopSignal: json['StopSignal'] as String?,
  stopGracePeriod: (json['StopGracePeriod'] as num?)?.toInt(),
  healthcheck: json['Healthcheck'] == null
      ? null
      : HealthConfig.fromJson(json['Healthcheck'] as Map<String, dynamic>),
  hosts:
      (json['Hosts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  dNSConfig: json['DNSConfig'] == null
      ? null
      : TaskSpec$ContainerSpec$DNSConfig.fromJson(
          json['DNSConfig'] as Map<String, dynamic>,
        ),
  secrets: (json['Secrets'] as List<dynamic>?)
      ?.map(
        (e) => TaskSpec$ContainerSpec$Secrets$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  oomScoreAdj: (json['OomScoreAdj'] as num?)?.toInt(),
  configs: (json['Configs'] as List<dynamic>?)
      ?.map(
        (e) => TaskSpec$ContainerSpec$Configs$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  isolation: taskSpec$ContainerSpecIsolationNullableFromJson(json['Isolation']),
  init: json['Init'] as bool?,
  sysctls: json['Sysctls'] as Map<String, dynamic>?,
  capabilityAdd:
      (json['CapabilityAdd'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  capabilityDrop:
      (json['CapabilityDrop'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  ulimits: (json['Ulimits'] as List<dynamic>?)
      ?.map(
        (e) => TaskSpec$ContainerSpec$Ulimits$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$TaskSpec$ContainerSpecToJson(
  TaskSpec$ContainerSpec instance,
) => <String, dynamic>{
  'Image': instance.image,
  'Labels': instance.labels,
  'Command': instance.command,
  'Args': instance.args,
  'Hostname': instance.hostname,
  'Env': instance.env,
  'Dir': instance.dir,
  'User': instance.user,
  'Groups': instance.groups,
  'Privileges': instance.privileges?.toJson(),
  'TTY': instance.tty,
  'OpenStdin': instance.openStdin,
  'ReadOnly': instance.readOnly,
  'Mounts': instance.mounts?.map((e) => e.toJson()).toList(),
  'StopSignal': instance.stopSignal,
  'StopGracePeriod': instance.stopGracePeriod,
  'Healthcheck': instance.healthcheck?.toJson(),
  'Hosts': instance.hosts,
  'DNSConfig': instance.dNSConfig?.toJson(),
  'Secrets': instance.secrets?.map((e) => e.toJson()).toList(),
  'OomScoreAdj': instance.oomScoreAdj,
  'Configs': instance.configs?.map((e) => e.toJson()).toList(),
  'Isolation': taskSpec$ContainerSpecIsolationNullableToJson(
    instance.isolation,
  ),
  'Init': instance.init,
  'Sysctls': instance.sysctls,
  'CapabilityAdd': instance.capabilityAdd,
  'CapabilityDrop': instance.capabilityDrop,
  'Ulimits': instance.ulimits?.map((e) => e.toJson()).toList(),
};

TaskSpec$NetworkAttachmentSpec _$TaskSpec$NetworkAttachmentSpecFromJson(
  Map<String, dynamic> json,
) =>
    TaskSpec$NetworkAttachmentSpec(containerID: json['ContainerID'] as String?);

Map<String, dynamic> _$TaskSpec$NetworkAttachmentSpecToJson(
  TaskSpec$NetworkAttachmentSpec instance,
) => <String, dynamic>{'ContainerID': instance.containerID};

TaskSpec$Resources _$TaskSpec$ResourcesFromJson(Map<String, dynamic> json) =>
    TaskSpec$Resources(
      limits: json['Limits'] == null
          ? null
          : Limit.fromJson(json['Limits'] as Map<String, dynamic>),
      reservations: json['Reservations'] == null
          ? null
          : ResourceObject.fromJson(
              json['Reservations'] as Map<String, dynamic>,
            ),
      swapBytes: (json['SwapBytes'] as num?)?.toInt(),
      memorySwappiness: (json['MemorySwappiness'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskSpec$ResourcesToJson(TaskSpec$Resources instance) =>
    <String, dynamic>{
      'Limits': instance.limits?.toJson(),
      'Reservations': instance.reservations?.toJson(),
      'SwapBytes': instance.swapBytes,
      'MemorySwappiness': instance.memorySwappiness,
    };

TaskSpec$RestartPolicy _$TaskSpec$RestartPolicyFromJson(
  Map<String, dynamic> json,
) => TaskSpec$RestartPolicy(
  condition: taskSpec$RestartPolicyConditionNullableFromJson(json['Condition']),
  delay: (json['Delay'] as num?)?.toInt(),
  maxAttempts: (json['MaxAttempts'] as num?)?.toInt(),
  window: (json['Window'] as num?)?.toInt(),
);

Map<String, dynamic> _$TaskSpec$RestartPolicyToJson(
  TaskSpec$RestartPolicy instance,
) => <String, dynamic>{
  'Condition': taskSpec$RestartPolicyConditionNullableToJson(
    instance.condition,
  ),
  'Delay': instance.delay,
  'MaxAttempts': instance.maxAttempts,
  'Window': instance.window,
};

TaskSpec$Placement _$TaskSpec$PlacementFromJson(Map<String, dynamic> json) =>
    TaskSpec$Placement(
      constraints:
          (json['Constraints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      preferences: (json['Preferences'] as List<dynamic>?)
          ?.map(
            (e) => TaskSpec$Placement$Preferences$Item.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      maxReplicas: (json['MaxReplicas'] as num?)?.toInt(),
      platforms:
          (json['Platforms'] as List<dynamic>?)
              ?.map((e) => Platform.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$TaskSpec$PlacementToJson(TaskSpec$Placement instance) =>
    <String, dynamic>{
      'Constraints': instance.constraints,
      'Preferences': instance.preferences?.map((e) => e.toJson()).toList(),
      'MaxReplicas': instance.maxReplicas,
      'Platforms': instance.platforms?.map((e) => e.toJson()).toList(),
    };

TaskSpec$LogDriver _$TaskSpec$LogDriverFromJson(Map<String, dynamic> json) =>
    TaskSpec$LogDriver(
      name: json['Name'] as String?,
      options: json['Options'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TaskSpec$LogDriverToJson(TaskSpec$LogDriver instance) =>
    <String, dynamic>{'Name': instance.name, 'Options': instance.options};

ServiceSpec$Mode _$ServiceSpec$ModeFromJson(Map<String, dynamic> json) =>
    ServiceSpec$Mode(
      replicated: json['Replicated'] == null
          ? null
          : ServiceSpec$Mode$Replicated.fromJson(
              json['Replicated'] as Map<String, dynamic>,
            ),
      global: json['Global'],
      replicatedJob: json['ReplicatedJob'] == null
          ? null
          : ServiceSpec$Mode$ReplicatedJob.fromJson(
              json['ReplicatedJob'] as Map<String, dynamic>,
            ),
      globalJob: json['GlobalJob'],
    );

Map<String, dynamic> _$ServiceSpec$ModeToJson(ServiceSpec$Mode instance) =>
    <String, dynamic>{
      'Replicated': instance.replicated?.toJson(),
      'Global': instance.global,
      'ReplicatedJob': instance.replicatedJob?.toJson(),
      'GlobalJob': instance.globalJob,
    };

ServiceSpec$UpdateConfig _$ServiceSpec$UpdateConfigFromJson(
  Map<String, dynamic> json,
) => ServiceSpec$UpdateConfig(
  parallelism: (json['Parallelism'] as num?)?.toInt(),
  delay: (json['Delay'] as num?)?.toInt(),
  failureAction: serviceSpec$UpdateConfigFailureActionNullableFromJson(
    json['FailureAction'],
  ),
  monitor: (json['Monitor'] as num?)?.toInt(),
  maxFailureRatio: (json['MaxFailureRatio'] as num?)?.toDouble(),
  order: serviceSpec$UpdateConfigOrderNullableFromJson(json['Order']),
);

Map<String, dynamic> _$ServiceSpec$UpdateConfigToJson(
  ServiceSpec$UpdateConfig instance,
) => <String, dynamic>{
  'Parallelism': instance.parallelism,
  'Delay': instance.delay,
  'FailureAction': serviceSpec$UpdateConfigFailureActionNullableToJson(
    instance.failureAction,
  ),
  'Monitor': instance.monitor,
  'MaxFailureRatio': instance.maxFailureRatio,
  'Order': serviceSpec$UpdateConfigOrderNullableToJson(instance.order),
};

ServiceSpec$RollbackConfig _$ServiceSpec$RollbackConfigFromJson(
  Map<String, dynamic> json,
) => ServiceSpec$RollbackConfig(
  parallelism: (json['Parallelism'] as num?)?.toInt(),
  delay: (json['Delay'] as num?)?.toInt(),
  failureAction: serviceSpec$RollbackConfigFailureActionNullableFromJson(
    json['FailureAction'],
  ),
  monitor: (json['Monitor'] as num?)?.toInt(),
  maxFailureRatio: (json['MaxFailureRatio'] as num?)?.toDouble(),
  order: serviceSpec$RollbackConfigOrderNullableFromJson(json['Order']),
);

Map<String, dynamic> _$ServiceSpec$RollbackConfigToJson(
  ServiceSpec$RollbackConfig instance,
) => <String, dynamic>{
  'Parallelism': instance.parallelism,
  'Delay': instance.delay,
  'FailureAction': serviceSpec$RollbackConfigFailureActionNullableToJson(
    instance.failureAction,
  ),
  'Monitor': instance.monitor,
  'MaxFailureRatio': instance.maxFailureRatio,
  'Order': serviceSpec$RollbackConfigOrderNullableToJson(instance.order),
};

Service$Endpoint _$Service$EndpointFromJson(Map<String, dynamic> json) =>
    Service$Endpoint(
      spec: json['Spec'] == null
          ? null
          : EndpointSpec.fromJson(json['Spec'] as Map<String, dynamic>),
      ports:
          (json['Ports'] as List<dynamic>?)
              ?.map(
                (e) => EndpointPortConfig.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      virtualIPs: (json['VirtualIPs'] as List<dynamic>?)
          ?.map(
            (e) => Service$Endpoint$VirtualIPs$Item.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );

Map<String, dynamic> _$Service$EndpointToJson(Service$Endpoint instance) =>
    <String, dynamic>{
      'Spec': instance.spec?.toJson(),
      'Ports': instance.ports?.map((e) => e.toJson()).toList(),
      'VirtualIPs': instance.virtualIPs?.map((e) => e.toJson()).toList(),
    };

Service$UpdateStatus _$Service$UpdateStatusFromJson(
  Map<String, dynamic> json,
) => Service$UpdateStatus(
  state: service$UpdateStatusStateNullableFromJson(json['State']),
  startedAt: json['StartedAt'] as String?,
  completedAt: json['CompletedAt'] as String?,
  message: json['Message'] as String?,
);

Map<String, dynamic> _$Service$UpdateStatusToJson(
  Service$UpdateStatus instance,
) => <String, dynamic>{
  'State': service$UpdateStatusStateNullableToJson(instance.state),
  'StartedAt': instance.startedAt,
  'CompletedAt': instance.completedAt,
  'Message': instance.message,
};

Service$ServiceStatus _$Service$ServiceStatusFromJson(
  Map<String, dynamic> json,
) => Service$ServiceStatus(
  runningTasks: (json['RunningTasks'] as num?)?.toInt(),
  desiredTasks: (json['DesiredTasks'] as num?)?.toInt(),
  completedTasks: (json['CompletedTasks'] as num?)?.toInt(),
);

Map<String, dynamic> _$Service$ServiceStatusToJson(
  Service$ServiceStatus instance,
) => <String, dynamic>{
  'RunningTasks': instance.runningTasks,
  'DesiredTasks': instance.desiredTasks,
  'CompletedTasks': instance.completedTasks,
};

Service$JobStatus _$Service$JobStatusFromJson(Map<String, dynamic> json) =>
    Service$JobStatus(
      jobIteration: json['JobIteration'] == null
          ? null
          : ObjectVersion.fromJson(
              json['JobIteration'] as Map<String, dynamic>,
            ),
      lastExecution: json['LastExecution'] as String?,
    );

Map<String, dynamic> _$Service$JobStatusToJson(Service$JobStatus instance) =>
    <String, dynamic>{
      'JobIteration': instance.jobIteration?.toJson(),
      'LastExecution': instance.lastExecution,
    };

ContainerSummary$HostConfig _$ContainerSummary$HostConfigFromJson(
  Map<String, dynamic> json,
) => ContainerSummary$HostConfig(
  networkMode: json['NetworkMode'] as String?,
  annotations: json['Annotations'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ContainerSummary$HostConfigToJson(
  ContainerSummary$HostConfig instance,
) => <String, dynamic>{
  'NetworkMode': instance.networkMode,
  'Annotations': instance.annotations,
};

ContainerSummary$NetworkSettings _$ContainerSummary$NetworkSettingsFromJson(
  Map<String, dynamic> json,
) => ContainerSummary$NetworkSettings(
  networks: json['Networks'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ContainerSummary$NetworkSettingsToJson(
  ContainerSummary$NetworkSettings instance,
) => <String, dynamic>{'Networks': instance.networks};

ContainerSummary$Health _$ContainerSummary$HealthFromJson(
  Map<String, dynamic> json,
) => ContainerSummary$Health(
  status: containerSummary$HealthStatusNullableFromJson(json['Status']),
  failingStreak: (json['FailingStreak'] as num?)?.toInt(),
);

Map<String, dynamic> _$ContainerSummary$HealthToJson(
  ContainerSummary$Health instance,
) => <String, dynamic>{
  'Status': containerSummary$HealthStatusNullableToJson(instance.status),
  'FailingStreak': instance.failingStreak,
};

SystemVersion$Platform _$SystemVersion$PlatformFromJson(
  Map<String, dynamic> json,
) => SystemVersion$Platform(name: json['Name'] as String);

Map<String, dynamic> _$SystemVersion$PlatformToJson(
  SystemVersion$Platform instance,
) => <String, dynamic>{'Name': instance.name};

SystemVersion$Components$Item _$SystemVersion$Components$ItemFromJson(
  Map<String, dynamic> json,
) => SystemVersion$Components$Item(
  name: json['Name'] as String,
  version: json['Version'] as String,
  details: json['Details'],
);

Map<String, dynamic> _$SystemVersion$Components$ItemToJson(
  SystemVersion$Components$Item instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Version': instance.version,
  'Details': instance.details,
};

SystemInfo$DefaultAddressPools$Item
_$SystemInfo$DefaultAddressPools$ItemFromJson(Map<String, dynamic> json) =>
    SystemInfo$DefaultAddressPools$Item(
      base: json['Base'] as String?,
      size: (json['Size'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SystemInfo$DefaultAddressPools$ItemToJson(
  SystemInfo$DefaultAddressPools$Item instance,
) => <String, dynamic>{'Base': instance.base, 'Size': instance.size};

ContainerdInfo$Namespaces _$ContainerdInfo$NamespacesFromJson(
  Map<String, dynamic> json,
) => ContainerdInfo$Namespaces(
  containers: json['Containers'] as String?,
  plugins: json['Plugins'] as String?,
);

Map<String, dynamic> _$ContainerdInfo$NamespacesToJson(
  ContainerdInfo$Namespaces instance,
) => <String, dynamic>{
  'Containers': instance.containers,
  'Plugins': instance.plugins,
};

ClusterVolume$Info _$ClusterVolume$InfoFromJson(Map<String, dynamic> json) =>
    ClusterVolume$Info(
      capacityBytes: (json['CapacityBytes'] as num?)?.toInt(),
      volumeContext: json['VolumeContext'] as Map<String, dynamic>?,
      volumeID: json['VolumeID'] as String?,
      accessibleTopology:
          (json['AccessibleTopology'] as List<dynamic>?)
              ?.map((e) => Topology.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ClusterVolume$InfoToJson(ClusterVolume$Info instance) =>
    <String, dynamic>{
      'CapacityBytes': instance.capacityBytes,
      'VolumeContext': instance.volumeContext,
      'VolumeID': instance.volumeID,
      'AccessibleTopology': instance.accessibleTopology
          ?.map((e) => e.toJson())
          .toList(),
    };

ClusterVolume$PublishStatus$Item _$ClusterVolume$PublishStatus$ItemFromJson(
  Map<String, dynamic> json,
) => ClusterVolume$PublishStatus$Item(
  nodeID: json['NodeID'] as String?,
  state: clusterVolume$PublishStatus$ItemStateNullableFromJson(json['State']),
  publishContext: json['PublishContext'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$ClusterVolume$PublishStatus$ItemToJson(
  ClusterVolume$PublishStatus$Item instance,
) => <String, dynamic>{
  'NodeID': instance.nodeID,
  'State': clusterVolume$PublishStatus$ItemStateNullableToJson(instance.state),
  'PublishContext': instance.publishContext,
};

ClusterVolumeSpec$AccessMode _$ClusterVolumeSpec$AccessModeFromJson(
  Map<String, dynamic> json,
) => ClusterVolumeSpec$AccessMode(
  scope:
      ClusterVolumeSpec$AccessMode.clusterVolumeSpec$AccessModeScopeScopeNullableFromJson(
        json['Scope'],
      ),
  sharing:
      ClusterVolumeSpec$AccessMode.clusterVolumeSpec$AccessModeSharingSharingNullableFromJson(
        json['Sharing'],
      ),
  mountVolume: json['MountVolume'],
  secrets: (json['Secrets'] as List<dynamic>?)
      ?.map(
        (e) => ClusterVolumeSpec$AccessMode$Secrets$Item.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  accessibilityRequirements: json['AccessibilityRequirements'] == null
      ? null
      : ClusterVolumeSpec$AccessMode$AccessibilityRequirements.fromJson(
          json['AccessibilityRequirements'] as Map<String, dynamic>,
        ),
  capacityRange: json['CapacityRange'] == null
      ? null
      : ClusterVolumeSpec$AccessMode$CapacityRange.fromJson(
          json['CapacityRange'] as Map<String, dynamic>,
        ),
  availability:
      ClusterVolumeSpec$AccessMode.clusterVolumeSpec$AccessModeAvailabilityAvailabilityNullableFromJson(
        json['Availability'],
      ),
);

Map<String, dynamic> _$ClusterVolumeSpec$AccessModeToJson(
  ClusterVolumeSpec$AccessMode instance,
) => <String, dynamic>{
  'Scope': clusterVolumeSpec$AccessModeScopeNullableToJson(instance.scope),
  'Sharing': clusterVolumeSpec$AccessModeSharingNullableToJson(
    instance.sharing,
  ),
  'MountVolume': instance.mountVolume,
  'Secrets': instance.secrets?.map((e) => e.toJson()).toList(),
  'AccessibilityRequirements': instance.accessibilityRequirements?.toJson(),
  'CapacityRange': instance.capacityRange?.toJson(),
  'Availability': clusterVolumeSpec$AccessModeAvailabilityNullableToJson(
    instance.availability,
  ),
};

ImageManifestSummary$Size _$ImageManifestSummary$SizeFromJson(
  Map<String, dynamic> json,
) => ImageManifestSummary$Size(
  total: (json['Total'] as num).toInt(),
  content: (json['Content'] as num).toInt(),
);

Map<String, dynamic> _$ImageManifestSummary$SizeToJson(
  ImageManifestSummary$Size instance,
) => <String, dynamic>{'Total': instance.total, 'Content': instance.content};

ImageManifestSummary$ImageData _$ImageManifestSummary$ImageDataFromJson(
  Map<String, dynamic> json,
) => ImageManifestSummary$ImageData(
  platform: json['Platform'] == null
      ? null
      : OCIPlatform.fromJson(json['Platform'] as Map<String, dynamic>),
  containers:
      (json['Containers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  size: ImageManifestSummary$ImageData$Size.fromJson(
    json['Size'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ImageManifestSummary$ImageDataToJson(
  ImageManifestSummary$ImageData instance,
) => <String, dynamic>{
  'Platform': instance.platform?.toJson(),
  'Containers': instance.containers,
  'Size': instance.size.toJson(),
};

ImageManifestSummary$AttestationData
_$ImageManifestSummary$AttestationDataFromJson(Map<String, dynamic> json) =>
    ImageManifestSummary$AttestationData($For: json['For'] as String);

Map<String, dynamic> _$ImageManifestSummary$AttestationDataToJson(
  ImageManifestSummary$AttestationData instance,
) => <String, dynamic>{'For': instance.$For};

Mount$VolumeOptions$DriverConfig _$Mount$VolumeOptions$DriverConfigFromJson(
  Map<String, dynamic> json,
) => Mount$VolumeOptions$DriverConfig(
  name: json['Name'] as String?,
  options: json['Options'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$Mount$VolumeOptions$DriverConfigToJson(
  Mount$VolumeOptions$DriverConfig instance,
) => <String, dynamic>{'Name': instance.name, 'Options': instance.options};

Plugin$Config$Interface _$Plugin$Config$InterfaceFromJson(
  Map<String, dynamic> json,
) => Plugin$Config$Interface(
  types:
      (json['Types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
  socket: json['Socket'] as String,
  protocolScheme: plugin$Config$InterfaceProtocolSchemeNullableFromJson(
    json['ProtocolScheme'],
  ),
);

Map<String, dynamic> _$Plugin$Config$InterfaceToJson(
  Plugin$Config$Interface instance,
) => <String, dynamic>{
  'Types': instance.types,
  'Socket': instance.socket,
  'ProtocolScheme': plugin$Config$InterfaceProtocolSchemeNullableToJson(
    instance.protocolScheme,
  ),
};

Plugin$Config$User _$Plugin$Config$UserFromJson(Map<String, dynamic> json) =>
    Plugin$Config$User(
      uid: (json['UID'] as num?)?.toInt(),
      gid: (json['GID'] as num?)?.toInt(),
    );

Map<String, dynamic> _$Plugin$Config$UserToJson(Plugin$Config$User instance) =>
    <String, dynamic>{'UID': instance.uid, 'GID': instance.gid};

Plugin$Config$Network _$Plugin$Config$NetworkFromJson(
  Map<String, dynamic> json,
) => Plugin$Config$Network(type: json['Type'] as String);

Map<String, dynamic> _$Plugin$Config$NetworkToJson(
  Plugin$Config$Network instance,
) => <String, dynamic>{'Type': instance.type};

Plugin$Config$Linux _$Plugin$Config$LinuxFromJson(Map<String, dynamic> json) =>
    Plugin$Config$Linux(
      capabilities:
          (json['Capabilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      allowAllDevices: json['AllowAllDevices'] as bool,
      devices:
          (json['Devices'] as List<dynamic>?)
              ?.map((e) => PluginDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$Plugin$Config$LinuxToJson(
  Plugin$Config$Linux instance,
) => <String, dynamic>{
  'Capabilities': instance.capabilities,
  'AllowAllDevices': instance.allowAllDevices,
  'Devices': instance.devices.map((e) => e.toJson()).toList(),
};

Plugin$Config$Args _$Plugin$Config$ArgsFromJson(
  Map<String, dynamic> json,
) => Plugin$Config$Args(
  name: json['Name'] as String,
  description: json['Description'] as String,
  settable:
      (json['Settable'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  $Value:
      (json['Value'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
);

Map<String, dynamic> _$Plugin$Config$ArgsToJson(Plugin$Config$Args instance) =>
    <String, dynamic>{
      'Name': instance.name,
      'Description': instance.description,
      'Settable': instance.settable,
      'Value': instance.$Value,
    };

Plugin$Config$Rootfs _$Plugin$Config$RootfsFromJson(
  Map<String, dynamic> json,
) => Plugin$Config$Rootfs(
  type: json['type'] as String?,
  diffIds:
      (json['diff_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$Plugin$Config$RootfsToJson(
  Plugin$Config$Rootfs instance,
) => <String, dynamic>{'type': instance.type, 'diff_ids': instance.diffIds};

SwarmSpec$CAConfig$ExternalCAs$Item
_$SwarmSpec$CAConfig$ExternalCAs$ItemFromJson(
  Map<String, dynamic> json,
) => SwarmSpec$CAConfig$ExternalCAs$Item(
  protocol:
      SwarmSpec$CAConfig$ExternalCAs$Item.swarmSpec$CAConfig$ExternalCAs$ItemProtocolProtocolNullableFromJson(
        json['Protocol'],
      ),
  url: json['URL'] as String?,
  options: json['Options'] as Map<String, dynamic>?,
  cACert: json['CACert'] as String?,
);

Map<String, dynamic> _$SwarmSpec$CAConfig$ExternalCAs$ItemToJson(
  SwarmSpec$CAConfig$ExternalCAs$Item instance,
) => <String, dynamic>{
  'Protocol': swarmSpec$CAConfig$ExternalCAs$ItemProtocolNullableToJson(
    instance.protocol,
  ),
  'URL': instance.url,
  'Options': instance.options,
  'CACert': instance.cACert,
};

SwarmSpec$TaskDefaults$LogDriver _$SwarmSpec$TaskDefaults$LogDriverFromJson(
  Map<String, dynamic> json,
) => SwarmSpec$TaskDefaults$LogDriver(
  name: json['Name'] as String?,
  options: json['Options'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$SwarmSpec$TaskDefaults$LogDriverToJson(
  SwarmSpec$TaskDefaults$LogDriver instance,
) => <String, dynamic>{'Name': instance.name, 'Options': instance.options};

TaskSpec$ContainerSpec$Privileges _$TaskSpec$ContainerSpec$PrivilegesFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec$Privileges(
  credentialSpec: json['CredentialSpec'] == null
      ? null
      : TaskSpec$ContainerSpec$Privileges$CredentialSpec.fromJson(
          json['CredentialSpec'] as Map<String, dynamic>,
        ),
  sELinuxContext: json['SELinuxContext'] == null
      ? null
      : TaskSpec$ContainerSpec$Privileges$SELinuxContext.fromJson(
          json['SELinuxContext'] as Map<String, dynamic>,
        ),
  seccomp: json['Seccomp'] == null
      ? null
      : TaskSpec$ContainerSpec$Privileges$Seccomp.fromJson(
          json['Seccomp'] as Map<String, dynamic>,
        ),
  appArmor: json['AppArmor'] == null
      ? null
      : TaskSpec$ContainerSpec$Privileges$AppArmor.fromJson(
          json['AppArmor'] as Map<String, dynamic>,
        ),
  noNewPrivileges: json['NoNewPrivileges'] as bool?,
);

Map<String, dynamic> _$TaskSpec$ContainerSpec$PrivilegesToJson(
  TaskSpec$ContainerSpec$Privileges instance,
) => <String, dynamic>{
  'CredentialSpec': instance.credentialSpec?.toJson(),
  'SELinuxContext': instance.sELinuxContext?.toJson(),
  'Seccomp': instance.seccomp?.toJson(),
  'AppArmor': instance.appArmor?.toJson(),
  'NoNewPrivileges': instance.noNewPrivileges,
};

TaskSpec$ContainerSpec$DNSConfig _$TaskSpec$ContainerSpec$DNSConfigFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec$DNSConfig(
  nameservers:
      (json['Nameservers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  search:
      (json['Search'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  options:
      (json['Options'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$TaskSpec$ContainerSpec$DNSConfigToJson(
  TaskSpec$ContainerSpec$DNSConfig instance,
) => <String, dynamic>{
  'Nameservers': instance.nameservers,
  'Search': instance.search,
  'Options': instance.options,
};

TaskSpec$ContainerSpec$Secrets$Item
_$TaskSpec$ContainerSpec$Secrets$ItemFromJson(Map<String, dynamic> json) =>
    TaskSpec$ContainerSpec$Secrets$Item(
      file: json['File'] == null
          ? null
          : TaskSpec$ContainerSpec$Secrets$Item$File.fromJson(
              json['File'] as Map<String, dynamic>,
            ),
      secretID: json['SecretID'] as String?,
      secretName: json['SecretName'] as String?,
    );

Map<String, dynamic> _$TaskSpec$ContainerSpec$Secrets$ItemToJson(
  TaskSpec$ContainerSpec$Secrets$Item instance,
) => <String, dynamic>{
  'File': instance.file?.toJson(),
  'SecretID': instance.secretID,
  'SecretName': instance.secretName,
};

TaskSpec$ContainerSpec$Configs$Item
_$TaskSpec$ContainerSpec$Configs$ItemFromJson(Map<String, dynamic> json) =>
    TaskSpec$ContainerSpec$Configs$Item(
      file: json['File'] == null
          ? null
          : TaskSpec$ContainerSpec$Configs$Item$File.fromJson(
              json['File'] as Map<String, dynamic>,
            ),
      runtime: json['Runtime'],
      configID: json['ConfigID'] as String?,
      configName: json['ConfigName'] as String?,
    );

Map<String, dynamic> _$TaskSpec$ContainerSpec$Configs$ItemToJson(
  TaskSpec$ContainerSpec$Configs$Item instance,
) => <String, dynamic>{
  'File': instance.file?.toJson(),
  'Runtime': instance.runtime,
  'ConfigID': instance.configID,
  'ConfigName': instance.configName,
};

TaskSpec$ContainerSpec$Ulimits$Item
_$TaskSpec$ContainerSpec$Ulimits$ItemFromJson(Map<String, dynamic> json) =>
    TaskSpec$ContainerSpec$Ulimits$Item(
      name: json['Name'] as String?,
      soft: (json['Soft'] as num?)?.toInt(),
      hard: (json['Hard'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskSpec$ContainerSpec$Ulimits$ItemToJson(
  TaskSpec$ContainerSpec$Ulimits$Item instance,
) => <String, dynamic>{
  'Name': instance.name,
  'Soft': instance.soft,
  'Hard': instance.hard,
};

TaskSpec$Placement$Preferences$Item
_$TaskSpec$Placement$Preferences$ItemFromJson(Map<String, dynamic> json) =>
    TaskSpec$Placement$Preferences$Item(
      spread: json['Spread'] == null
          ? null
          : TaskSpec$Placement$Preferences$Item$Spread.fromJson(
              json['Spread'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TaskSpec$Placement$Preferences$ItemToJson(
  TaskSpec$Placement$Preferences$Item instance,
) => <String, dynamic>{'Spread': instance.spread?.toJson()};

ServiceSpec$Mode$Replicated _$ServiceSpec$Mode$ReplicatedFromJson(
  Map<String, dynamic> json,
) => ServiceSpec$Mode$Replicated(replicas: (json['Replicas'] as num?)?.toInt());

Map<String, dynamic> _$ServiceSpec$Mode$ReplicatedToJson(
  ServiceSpec$Mode$Replicated instance,
) => <String, dynamic>{'Replicas': instance.replicas};

ServiceSpec$Mode$ReplicatedJob _$ServiceSpec$Mode$ReplicatedJobFromJson(
  Map<String, dynamic> json,
) => ServiceSpec$Mode$ReplicatedJob(
  maxConcurrent: (json['MaxConcurrent'] as num?)?.toInt(),
  totalCompletions: (json['TotalCompletions'] as num?)?.toInt(),
);

Map<String, dynamic> _$ServiceSpec$Mode$ReplicatedJobToJson(
  ServiceSpec$Mode$ReplicatedJob instance,
) => <String, dynamic>{
  'MaxConcurrent': instance.maxConcurrent,
  'TotalCompletions': instance.totalCompletions,
};

Service$Endpoint$VirtualIPs$Item _$Service$Endpoint$VirtualIPs$ItemFromJson(
  Map<String, dynamic> json,
) => Service$Endpoint$VirtualIPs$Item(
  networkID: json['NetworkID'] as String?,
  addr: json['Addr'] as String?,
);

Map<String, dynamic> _$Service$Endpoint$VirtualIPs$ItemToJson(
  Service$Endpoint$VirtualIPs$Item instance,
) => <String, dynamic>{'NetworkID': instance.networkID, 'Addr': instance.addr};

ClusterVolumeSpec$AccessMode$Secrets$Item
_$ClusterVolumeSpec$AccessMode$Secrets$ItemFromJson(
  Map<String, dynamic> json,
) => ClusterVolumeSpec$AccessMode$Secrets$Item(
  key: json['Key'] as String?,
  secret: json['Secret'] as String?,
);

Map<String, dynamic> _$ClusterVolumeSpec$AccessMode$Secrets$ItemToJson(
  ClusterVolumeSpec$AccessMode$Secrets$Item instance,
) => <String, dynamic>{'Key': instance.key, 'Secret': instance.secret};

ClusterVolumeSpec$AccessMode$AccessibilityRequirements
_$ClusterVolumeSpec$AccessMode$AccessibilityRequirementsFromJson(
  Map<String, dynamic> json,
) => ClusterVolumeSpec$AccessMode$AccessibilityRequirements(
  requisite:
      (json['Requisite'] as List<dynamic>?)
          ?.map((e) => Topology.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  preferred:
      (json['Preferred'] as List<dynamic>?)
          ?.map((e) => Topology.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic>
_$ClusterVolumeSpec$AccessMode$AccessibilityRequirementsToJson(
  ClusterVolumeSpec$AccessMode$AccessibilityRequirements instance,
) => <String, dynamic>{
  'Requisite': instance.requisite?.map((e) => e.toJson()).toList(),
  'Preferred': instance.preferred?.map((e) => e.toJson()).toList(),
};

ClusterVolumeSpec$AccessMode$CapacityRange
_$ClusterVolumeSpec$AccessMode$CapacityRangeFromJson(
  Map<String, dynamic> json,
) => ClusterVolumeSpec$AccessMode$CapacityRange(
  requiredBytes: (json['RequiredBytes'] as num?)?.toInt(),
  limitBytes: (json['LimitBytes'] as num?)?.toInt(),
);

Map<String, dynamic> _$ClusterVolumeSpec$AccessMode$CapacityRangeToJson(
  ClusterVolumeSpec$AccessMode$CapacityRange instance,
) => <String, dynamic>{
  'RequiredBytes': instance.requiredBytes,
  'LimitBytes': instance.limitBytes,
};

ImageManifestSummary$ImageData$Size
_$ImageManifestSummary$ImageData$SizeFromJson(Map<String, dynamic> json) =>
    ImageManifestSummary$ImageData$Size(
      unpacked: (json['Unpacked'] as num).toInt(),
    );

Map<String, dynamic> _$ImageManifestSummary$ImageData$SizeToJson(
  ImageManifestSummary$ImageData$Size instance,
) => <String, dynamic>{'Unpacked': instance.unpacked};

TaskSpec$ContainerSpec$Privileges$CredentialSpec
_$TaskSpec$ContainerSpec$Privileges$CredentialSpecFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec$Privileges$CredentialSpec(
  config: json['Config'] as String?,
  file: json['File'] as String?,
  registry: json['Registry'] as String?,
);

Map<String, dynamic> _$TaskSpec$ContainerSpec$Privileges$CredentialSpecToJson(
  TaskSpec$ContainerSpec$Privileges$CredentialSpec instance,
) => <String, dynamic>{
  'Config': instance.config,
  'File': instance.file,
  'Registry': instance.registry,
};

TaskSpec$ContainerSpec$Privileges$SELinuxContext
_$TaskSpec$ContainerSpec$Privileges$SELinuxContextFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec$Privileges$SELinuxContext(
  disable: json['Disable'] as bool?,
  user: json['User'] as String?,
  role: json['Role'] as String?,
  type: json['Type'] as String?,
  level: json['Level'] as String?,
);

Map<String, dynamic> _$TaskSpec$ContainerSpec$Privileges$SELinuxContextToJson(
  TaskSpec$ContainerSpec$Privileges$SELinuxContext instance,
) => <String, dynamic>{
  'Disable': instance.disable,
  'User': instance.user,
  'Role': instance.role,
  'Type': instance.type,
  'Level': instance.level,
};

TaskSpec$ContainerSpec$Privileges$Seccomp
_$TaskSpec$ContainerSpec$Privileges$SeccompFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec$Privileges$Seccomp(
  mode: taskSpec$ContainerSpec$Privileges$SeccompModeNullableFromJson(
    json['Mode'],
  ),
  profile: json['Profile'] as String?,
);

Map<String, dynamic> _$TaskSpec$ContainerSpec$Privileges$SeccompToJson(
  TaskSpec$ContainerSpec$Privileges$Seccomp instance,
) => <String, dynamic>{
  'Mode': taskSpec$ContainerSpec$Privileges$SeccompModeNullableToJson(
    instance.mode,
  ),
  'Profile': instance.profile,
};

TaskSpec$ContainerSpec$Privileges$AppArmor
_$TaskSpec$ContainerSpec$Privileges$AppArmorFromJson(
  Map<String, dynamic> json,
) => TaskSpec$ContainerSpec$Privileges$AppArmor(
  mode: taskSpec$ContainerSpec$Privileges$AppArmorModeNullableFromJson(
    json['Mode'],
  ),
);

Map<String, dynamic> _$TaskSpec$ContainerSpec$Privileges$AppArmorToJson(
  TaskSpec$ContainerSpec$Privileges$AppArmor instance,
) => <String, dynamic>{
  'Mode': taskSpec$ContainerSpec$Privileges$AppArmorModeNullableToJson(
    instance.mode,
  ),
};

TaskSpec$ContainerSpec$Secrets$Item$File
_$TaskSpec$ContainerSpec$Secrets$Item$FileFromJson(Map<String, dynamic> json) =>
    TaskSpec$ContainerSpec$Secrets$Item$File(
      name: json['Name'] as String?,
      uid: json['UID'] as String?,
      gid: json['GID'] as String?,
      mode: (json['Mode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskSpec$ContainerSpec$Secrets$Item$FileToJson(
  TaskSpec$ContainerSpec$Secrets$Item$File instance,
) => <String, dynamic>{
  'Name': instance.name,
  'UID': instance.uid,
  'GID': instance.gid,
  'Mode': instance.mode,
};

TaskSpec$ContainerSpec$Configs$Item$File
_$TaskSpec$ContainerSpec$Configs$Item$FileFromJson(Map<String, dynamic> json) =>
    TaskSpec$ContainerSpec$Configs$Item$File(
      name: json['Name'] as String?,
      uid: json['UID'] as String?,
      gid: json['GID'] as String?,
      mode: (json['Mode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskSpec$ContainerSpec$Configs$Item$FileToJson(
  TaskSpec$ContainerSpec$Configs$Item$File instance,
) => <String, dynamic>{
  'Name': instance.name,
  'UID': instance.uid,
  'GID': instance.gid,
  'Mode': instance.mode,
};

TaskSpec$Placement$Preferences$Item$Spread
_$TaskSpec$Placement$Preferences$Item$SpreadFromJson(
  Map<String, dynamic> json,
) => TaskSpec$Placement$Preferences$Item$Spread(
  spreadDescriptor: json['SpreadDescriptor'] as String?,
);

Map<String, dynamic> _$TaskSpec$Placement$Preferences$Item$SpreadToJson(
  TaskSpec$Placement$Preferences$Item$Spread instance,
) => <String, dynamic>{'SpreadDescriptor': instance.spreadDescriptor};
