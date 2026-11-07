import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum PortSummaryType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('tcp')
  tcp('tcp'),
  @JsonValue('udp')
  udp('udp'),
  @JsonValue('sctp')
  sctp('sctp');

  final String? value;

  const PortSummaryType(this.value);
}

enum MountType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('bind')
  bind('bind'),
  @JsonValue('cluster')
  cluster('cluster'),
  @JsonValue('image')
  image('image'),
  @JsonValue('npipe')
  npipe('npipe'),
  @JsonValue('tmpfs')
  tmpfs('tmpfs'),
  @JsonValue('volume')
  volume('volume');

  final String? value;

  const MountType(this.value);
}

enum Mount$BindOptionsPropagation {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('private')
  private('private'),
  @JsonValue('rprivate')
  rprivate('rprivate'),
  @JsonValue('shared')
  shared('shared'),
  @JsonValue('rshared')
  rshared('rshared'),
  @JsonValue('slave')
  slave('slave'),
  @JsonValue('rslave')
  rslave('rslave');

  final String? value;

  const Mount$BindOptionsPropagation(this.value);
}

enum RestartPolicyName {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('')
  $null(''),
  @JsonValue('no')
  no('no'),
  @JsonValue('always')
  always('always'),
  @JsonValue('unless-stopped')
  unlessStopped('unless-stopped'),
  @JsonValue('on-failure')
  onFailure('on-failure');

  final String? value;

  const RestartPolicyName(this.value);
}

enum HealthStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('none')
  none('none'),
  @JsonValue('starting')
  starting('starting'),
  @JsonValue('healthy')
  healthy('healthy'),
  @JsonValue('unhealthy')
  unhealthy('unhealthy');

  final String? value;

  const HealthStatus(this.value);
}

enum HostConfig$LogConfigType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('local')
  local('local'),
  @JsonValue('json-file')
  jsonFile('json-file'),
  @JsonValue('syslog')
  syslog('syslog'),
  @JsonValue('journald')
  journald('journald'),
  @JsonValue('gelf')
  gelf('gelf'),
  @JsonValue('fluentd')
  fluentd('fluentd'),
  @JsonValue('awslogs')
  awslogs('awslogs'),
  @JsonValue('splunk')
  splunk('splunk'),
  @JsonValue('etwlogs')
  etwlogs('etwlogs'),
  @JsonValue('none')
  none('none');

  final String? value;

  const HostConfig$LogConfigType(this.value);
}

enum HostConfigCgroupnsMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('private')
  private('private'),
  @JsonValue('host')
  host('host');

  final String? value;

  const HostConfigCgroupnsMode(this.value);
}

enum HostConfigIsolation {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('default')
  $default('default'),
  @JsonValue('process')
  process('process'),
  @JsonValue('hyperv')
  hyperv('hyperv'),
  @JsonValue('')
  $null('');

  final String? value;

  const HostConfigIsolation(this.value);
}

enum ChangeType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue(0)
  value_0(0),
  @JsonValue(1)
  value_1(1),
  @JsonValue(2)
  value_2(2);

  final int? value;

  const ChangeType(this.value);
}

enum SignatureTimestampType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('Tlog')
  tlog('Tlog'),
  @JsonValue('TimestampAuthority')
  timestampauthority('TimestampAuthority');

  final String? value;

  const SignatureTimestampType(this.value);
}

enum SignatureType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('bundle-v0.3')
  bundleV03('bundle-v0.3'),
  @JsonValue('simplesigning-v1')
  simplesigningV1('simplesigning-v1');

  final String? value;

  const SignatureType(this.value);
}

enum KnownSignerIdentity {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('DHI')
  dhi('DHI');

  final String? value;

  const KnownSignerIdentity(this.value);
}

enum VolumeScope {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('local')
  local('local'),
  @JsonValue('global')
  global('global');

  final String? value;

  const VolumeScope(this.value);
}

enum BuildCacheType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('internal')
  internal('internal'),
  @JsonValue('frontend')
  frontend('frontend'),
  @JsonValue('source.local')
  sourceLocal('source.local'),
  @JsonValue('source.git.checkout')
  sourceGitCheckout('source.git.checkout'),
  @JsonValue('exec.cachemount')
  execCachemount('exec.cachemount'),
  @JsonValue('regular')
  regular('regular');

  final String? value;

  const BuildCacheType(this.value);
}

enum Plugin$Config$InterfaceProtocolScheme {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('')
  $null(''),
  @JsonValue('moby.plugins.http/v1')
  mobyPluginsHttpV1('moby.plugins.http/v1');

  final String? value;

  const Plugin$Config$InterfaceProtocolScheme(this.value);
}

enum NodeSpecRole {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('worker')
  worker('worker'),
  @JsonValue('manager')
  manager('manager');

  final String? value;

  const NodeSpecRole(this.value);
}

enum NodeSpecAvailability {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('active')
  active('active'),
  @JsonValue('pause')
  pause('pause'),
  @JsonValue('drain')
  drain('drain');

  final String? value;

  const NodeSpecAvailability(this.value);
}

enum NodeState {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('unknown')
  unknown('unknown'),
  @JsonValue('down')
  down('down'),
  @JsonValue('ready')
  ready('ready'),
  @JsonValue('disconnected')
  disconnected('disconnected');

  final String? value;

  const NodeState(this.value);
}

enum Reachability {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('unknown')
  unknown('unknown'),
  @JsonValue('unreachable')
  unreachable('unreachable'),
  @JsonValue('reachable')
  reachable('reachable');

  final String? value;

  const Reachability(this.value);
}

enum SwarmSpec$CAConfig$ExternalCAs$ItemProtocol {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cfssl')
  cfssl('cfssl');

  final String? value;

  const SwarmSpec$CAConfig$ExternalCAs$ItemProtocol(this.value);
}

enum TaskSpec$ContainerSpec$Privileges$SeccompMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('default')
  $default('default'),
  @JsonValue('unconfined')
  unconfined('unconfined'),
  @JsonValue('custom')
  custom('custom');

  final String? value;

  const TaskSpec$ContainerSpec$Privileges$SeccompMode(this.value);
}

enum TaskSpec$ContainerSpec$Privileges$AppArmorMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('default')
  $default('default'),
  @JsonValue('disabled')
  disabled('disabled');

  final String? value;

  const TaskSpec$ContainerSpec$Privileges$AppArmorMode(this.value);
}

enum TaskSpec$ContainerSpecIsolation {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('default')
  $default('default'),
  @JsonValue('process')
  process('process'),
  @JsonValue('hyperv')
  hyperv('hyperv'),
  @JsonValue('')
  $null('');

  final String? value;

  const TaskSpec$ContainerSpecIsolation(this.value);
}

enum TaskSpec$RestartPolicyCondition {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('none')
  none('none'),
  @JsonValue('on-failure')
  onFailure('on-failure'),
  @JsonValue('any')
  any('any');

  final String? value;

  const TaskSpec$RestartPolicyCondition(this.value);
}

enum TaskState {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('new')
  $new('new'),
  @JsonValue('allocated')
  allocated('allocated'),
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('assigned')
  assigned('assigned'),
  @JsonValue('accepted')
  accepted('accepted'),
  @JsonValue('preparing')
  preparing('preparing'),
  @JsonValue('ready')
  ready('ready'),
  @JsonValue('starting')
  starting('starting'),
  @JsonValue('running')
  running('running'),
  @JsonValue('complete')
  complete('complete'),
  @JsonValue('shutdown')
  shutdown('shutdown'),
  @JsonValue('failed')
  failed('failed'),
  @JsonValue('rejected')
  rejected('rejected'),
  @JsonValue('remove')
  remove('remove'),
  @JsonValue('orphaned')
  orphaned('orphaned');

  final String? value;

  const TaskState(this.value);
}

enum ServiceSpec$UpdateConfigFailureAction {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('continue')
  $continue('continue'),
  @JsonValue('pause')
  pause('pause'),
  @JsonValue('rollback')
  rollback('rollback');

  final String? value;

  const ServiceSpec$UpdateConfigFailureAction(this.value);
}

enum ServiceSpec$UpdateConfigOrder {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('stop-first')
  stopFirst('stop-first'),
  @JsonValue('start-first')
  startFirst('start-first');

  final String? value;

  const ServiceSpec$UpdateConfigOrder(this.value);
}

enum ServiceSpec$RollbackConfigFailureAction {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('continue')
  $continue('continue'),
  @JsonValue('pause')
  pause('pause');

  final String? value;

  const ServiceSpec$RollbackConfigFailureAction(this.value);
}

enum ServiceSpec$RollbackConfigOrder {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('stop-first')
  stopFirst('stop-first'),
  @JsonValue('start-first')
  startFirst('start-first');

  final String? value;

  const ServiceSpec$RollbackConfigOrder(this.value);
}

enum EndpointPortConfigProtocol {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('tcp')
  tcp('tcp'),
  @JsonValue('udp')
  udp('udp'),
  @JsonValue('sctp')
  sctp('sctp');

  final String? value;

  const EndpointPortConfigProtocol(this.value);
}

enum EndpointPortConfigPublishMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ingress')
  ingress('ingress'),
  @JsonValue('host')
  host('host');

  final String? value;

  const EndpointPortConfigPublishMode(this.value);
}

enum EndpointSpecMode {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('vip')
  vip('vip'),
  @JsonValue('dnsrr')
  dnsrr('dnsrr');

  final String? value;

  const EndpointSpecMode(this.value);
}

enum Service$UpdateStatusState {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('updating')
  updating('updating'),
  @JsonValue('paused')
  paused('paused'),
  @JsonValue('completed')
  completed('completed');

  final String? value;

  const Service$UpdateStatusState(this.value);
}

enum ContainerSummaryState {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('created')
  created('created'),
  @JsonValue('running')
  running('running'),
  @JsonValue('paused')
  paused('paused'),
  @JsonValue('restarting')
  restarting('restarting'),
  @JsonValue('exited')
  exited('exited'),
  @JsonValue('removing')
  removing('removing'),
  @JsonValue('dead')
  dead('dead');

  final String? value;

  const ContainerSummaryState(this.value);
}

enum ContainerSummary$HealthStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('none')
  none('none'),
  @JsonValue('starting')
  starting('starting'),
  @JsonValue('healthy')
  healthy('healthy'),
  @JsonValue('unhealthy')
  unhealthy('unhealthy');

  final String? value;

  const ContainerSummary$HealthStatus(this.value);
}

enum ContainerStateStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('created')
  created('created'),
  @JsonValue('running')
  running('running'),
  @JsonValue('paused')
  paused('paused'),
  @JsonValue('restarting')
  restarting('restarting'),
  @JsonValue('removing')
  removing('removing'),
  @JsonValue('exited')
  exited('exited'),
  @JsonValue('dead')
  dead('dead');

  final String? value;

  const ContainerStateStatus(this.value);
}

enum SystemInfoCgroupDriver {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('cgroupfs')
  cgroupfs('cgroupfs'),
  @JsonValue('systemd')
  systemd('systemd'),
  @JsonValue('none')
  none('none');

  final String? value;

  const SystemInfoCgroupDriver(this.value);
}

enum SystemInfoCgroupVersion {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('1')
  value_1('1'),
  @JsonValue('2')
  value_2('2');

  final String? value;

  const SystemInfoCgroupVersion(this.value);
}

enum SystemInfoIsolation {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('default')
  $default('default'),
  @JsonValue('hyperv')
  hyperv('hyperv'),
  @JsonValue('process')
  process('process'),
  @JsonValue('')
  $null('');

  final String? value;

  const SystemInfoIsolation(this.value);
}

enum LocalNodeState {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('')
  $null(''),
  @JsonValue('inactive')
  inactive('inactive'),
  @JsonValue('pending')
  pending('pending'),
  @JsonValue('active')
  active('active'),
  @JsonValue('error')
  error('error'),
  @JsonValue('locked')
  locked('locked');

  final String? value;

  const LocalNodeState(this.value);
}

enum EventMessageType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('builder')
  builder('builder'),
  @JsonValue('config')
  config('config'),
  @JsonValue('container')
  container('container'),
  @JsonValue('daemon')
  daemon('daemon'),
  @JsonValue('image')
  image('image'),
  @JsonValue('network')
  network('network'),
  @JsonValue('node')
  node('node'),
  @JsonValue('plugin')
  plugin('plugin'),
  @JsonValue('secret')
  secret('secret'),
  @JsonValue('service')
  service('service'),
  @JsonValue('volume')
  volume('volume');

  final String? value;

  const EventMessageType(this.value);
}

enum EventMessageScope {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('local')
  local('local'),
  @JsonValue('swarm')
  swarm('swarm');

  final String? value;

  const EventMessageScope(this.value);
}

enum ClusterVolume$PublishStatus$ItemState {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('pending-publish')
  pendingPublish('pending-publish'),
  @JsonValue('published')
  published('published'),
  @JsonValue('pending-node-unpublish')
  pendingNodeUnpublish('pending-node-unpublish'),
  @JsonValue('pending-controller-unpublish')
  pendingControllerUnpublish('pending-controller-unpublish');

  final String? value;

  const ClusterVolume$PublishStatus$ItemState(this.value);
}

enum ClusterVolumeSpec$AccessModeScope {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('single')
  single('single'),
  @JsonValue('multi')
  multi('multi');

  final String? value;

  const ClusterVolumeSpec$AccessModeScope(this.value);
}

enum ClusterVolumeSpec$AccessModeSharing {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('none')
  none('none'),
  @JsonValue('readonly')
  readonly('readonly'),
  @JsonValue('onewriter')
  onewriter('onewriter'),
  @JsonValue('all')
  all('all');

  final String? value;

  const ClusterVolumeSpec$AccessModeSharing(this.value);
}

enum ClusterVolumeSpec$AccessModeAvailability {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('active')
  active('active'),
  @JsonValue('pause')
  pause('pause'),
  @JsonValue('drain')
  drain('drain');

  final String? value;

  const ClusterVolumeSpec$AccessModeAvailability(this.value);
}

enum ImageManifestSummaryKind {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('image')
  image('image'),
  @JsonValue('attestation')
  attestation('attestation'),
  @JsonValue('unknown')
  unknown('unknown');

  final String? value;

  const ImageManifestSummaryKind(this.value);
}

enum ContainersIdWaitPostCondition {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('not-running')
  notRunning('not-running'),
  @JsonValue('next-exit')
  nextExit('next-exit'),
  @JsonValue('removed')
  removed('removed');

  final String? value;

  const ContainersIdWaitPostCondition(this.value);
}

enum BuildPostContentType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('application/x-tar')
  applicationXTar('application/x-tar');

  final String? value;

  const BuildPostContentType(this.value);
}

enum BuildPostVersion {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('1')
  value_1('1'),
  @JsonValue('2')
  value_2('2');

  final String? value;

  const BuildPostVersion(this.value);
}

enum SystemDfGetType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('container')
  container('container'),
  @JsonValue('image')
  image('image'),
  @JsonValue('volume')
  volume('volume'),
  @JsonValue('build-cache')
  buildCache('build-cache');

  final String? value;

  const SystemDfGetType(this.value);
}

enum ServicesIdUpdatePostRegistryAuthFrom {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('spec')
  spec('spec'),
  @JsonValue('previous-spec')
  previousSpec('previous-spec');

  final String? value;

  const ServicesIdUpdatePostRegistryAuthFrom(this.value);
}
