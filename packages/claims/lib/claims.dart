/// Dominio de reclamos bidireccionales (HAB-39).
///
/// Punto de entrada: [Claim], [ClaimMachine], [ClaimTrackingCode],
/// [ClaimCauses], [ClaimStatus], [ClaimDirection], [ClaimActor].
library claims;

export 'src/claim.dart';
export 'src/claim_causes.dart';
export 'src/claim_direction.dart';
export 'src/claim_machine.dart';
export 'src/claim_status.dart';
export 'src/claim_tracking_code.dart';
