// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library vm.metadata.direct_call;

import 'package:kernel/ast.dart';

/// Metadata for annotating method invocations converted to direct calls.
class DirectCallMetadata {
  final Member target;
  final bool checkReceiverForNull;

  DirectCallMetadata(this.target, this.checkReceiverForNull);
}

/// Repository for [DirectCallMetadata].
class DirectCallMetadataRepository
    extends MetadataRepository<DirectCallMetadata> {
  @override
  final String tag = 'vm.direct-call.metadata';

  @override
  final Map<TreeNode, DirectCallMetadata> mapping =
      <TreeNode, DirectCallMetadata>{};

  @override
  void writeToBinary(DirectCallMetadata metadata, BinarySink sink) {
    sink.writeCanonicalNameReference(getCanonicalNameOfMember(metadata.target));
    sink.writeByte(metadata.checkReceiverForNull ? 1 : 0);
  }

  @override
  DirectCallMetadata readFromBinary(BinarySource source) {
    var target = source.readCanonicalNameReference()?.getReference()?.asMember;
    if (target == null) {
      throw 'DirectCallMetadata should have a non-null target';
    }
    var checkReceiverForNull = (source.readByte() != 0);
    return new DirectCallMetadata(target, checkReceiverForNull);
  }
}