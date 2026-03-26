/// All the data models used across the Hushh app.
///


// Data Partner

/// Represents a company or service that wants access to the user's data.
class DataPartner {
  const DataPartner({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.category,
    required this.description,
    required this.requestedFields,
    required this.accessDuration,
    this.isActive = false,
    this.lastUpdated,
    this.riskLevel = RiskLevel.low,
  });
  final String id;
  final String name;
  final String logoAsset;
  final String category;
  final String description;
  final List<DataField> requestedFields;
  final String accessDuration;
  final bool isActive;
  final DateTime? lastUpdated;
  final RiskLevel riskLevel;
  DataPartner copyWith({bool? isActive, DateTime? lastUpdated}) {
    return DataPartner(
      id: id,
      name: name,
      logoAsset: logoAsset,
      category: category,
      description: description,
      requestedFields: requestedFields,
      accessDuration: accessDuration,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      riskLevel: riskLevel,
    );
  }
}

class DataField {
  const DataField({
    required this.key,
    required this.label,
    required this.description,
    required this.sensitivity,
    this.isRequired = false,
  });

  final String key;
  final String label;
  final String description;
  final Sensitivity sensitivity;
  final bool isRequired;
}
enum RiskLevel { low, medium, high }

enum Sensitivity { low, medium, high }

class AuditEntry {
  const AuditEntry({
    required this.id,
    required this.partnerName,
    required this.partnerLogo,
    required this.action,
    required this.fields,
    required this.timestamp,
  });

  final String id;
  final String partnerName;
  final String partnerLogo;
  final AuditAction action;
  final List<String> fields;
  final DateTime timestamp;
}

enum AuditAction { shared, revoked, requested, updated }
class SampleData {
  SampleData._();

  static final List<DataField> commonFields = [
    const DataField(
      key: 'name',
      label: 'Full name',
      description: 'Your legal first and last name',
      sensitivity: Sensitivity.low,
      isRequired: true,
    ),
    const DataField(
      key: 'email',
      label: 'Email address',
      description: 'Used for account communication',
      sensitivity: Sensitivity.medium,
      isRequired: true,
    ),
    const DataField(
      key: 'location',
      label: 'Approximate location',
      description: 'City-level, not precise GPS',
      sensitivity: Sensitivity.medium,
    ),
    const DataField(
      key: 'purchase_history',
      label: 'Purchase history',
      description: 'Past 6 months of transactions',
      sensitivity: Sensitivity.high,
    ),
    const DataField(
      key: 'health_data',
      label: 'Health metrics',
      description: 'Step count and activity from wearables',
      sensitivity: Sensitivity.high,
    ),
    const DataField(
      key: 'browsing',
      label: 'Browsing interests',
      description: 'Aggregated topic interests — no URLs',
      sensitivity: Sensitivity.medium,
    ),
  ];

  static final List<DataPartner> partners = [
    DataPartner(
      id: 'p1',
      name: 'Spotify',
      logoAsset: '🎵',
      category: 'Entertainment',
      description:
      'Wants to personalise your music recommendations using your '
          'listening habits and general location.',
      requestedFields: [
        commonFields[0], // name
        commonFields[2], // location
      ],
      accessDuration: '12 months',
      isActive: true,
      lastUpdated: DateTime.now().subtract(const Duration(days: 3)),
      riskLevel: RiskLevel.low,
    ),
    DataPartner(
      id: 'p2',
      name: 'HealthTrack',
      logoAsset: '🏥',
      category: 'Healthcare',
      description:
      'Connects your wearable data to personalise wellness programs '
          'and insurance pricing models.',
      requestedFields: [
        commonFields[0], // name
        commonFields[1], // email
        commonFields[4], // health data
      ],
      accessDuration: '6 months',
      isActive: false,
      riskLevel: RiskLevel.high,
    ),
    DataPartner(
      id: 'p3',
      name: 'ShopLens',
      logoAsset: '🛍️',
      category: 'Retail',
      description:
      'Retail analytics platform that builds shopper profiles to '
          'improve ad targeting across partner stores.',
      requestedFields: [
        commonFields[0], // name
        commonFields[1], // email
        commonFields[3], // purchase history
        commonFields[5], // browsing
      ],
      accessDuration: '3 months',
      isActive: true,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 6)),
      riskLevel: RiskLevel.medium,
    ),
    DataPartner(
      id: 'p4',
      name: 'NewsFlow',
      logoAsset: '📰',
      category: 'Media',
      description:
      'News curation app that uses your reading interests to '
          'surface relevant articles without storing identifiers.',
      requestedFields: [
        commonFields[5], // browsing
      ],
      accessDuration: '1 month',
      isActive: true,
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      riskLevel: RiskLevel.low,
    ),
  ];

  static final List<AuditEntry> auditLog = [
    AuditEntry(
      id: 'a1',
      partnerName: 'Spotify',
      partnerLogo: '🎵',
      action: AuditAction.shared,
      fields: ['Full name', 'Approximate location'],
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    AuditEntry(
      id: 'a2',
      partnerName: 'ShopLens',
      partnerLogo: '🛍️',
      action: AuditAction.shared,
      fields: ['Full name', 'Email address', 'Purchase history'],
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    AuditEntry(
      id: 'a3',
      partnerName: 'HealthTrack',
      partnerLogo: '🏥',
      action: AuditAction.revoked,
      fields: ['Health metrics'],
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AuditEntry(
      id: 'a4',
      partnerName: 'NewsFlow',
      partnerLogo: '📰',
      action: AuditAction.requested,
      fields: ['Browsing interests'],
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AuditEntry(
      id: 'a5',
      partnerName: 'ShopLens',
      partnerLogo: '🛍️',
      action: AuditAction.updated,
      fields: ['Browsing interests'],
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];
}
