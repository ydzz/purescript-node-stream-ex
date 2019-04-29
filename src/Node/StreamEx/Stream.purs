module Node.StreamEx.Stream (
    fromWritableStream,
    fromReadableStream,
    fromDuplex
) where

import Node.Stream as S
import Node.StreamEx.Types as SEX
import Unsafe.Coerce (unsafeCoerce)

fromWritableStream::forall r a. S.Writable r -> SEX.Writable a
fromWritableStream w = SEX.Writable (unsafeCoerce w)

fromReadableStream::forall r a.S.Readable r -> SEX.Readable a
fromReadableStream r = SEX.Readable (unsafeCoerce r)

fromDuplex::forall a.S.Duplex -> SEX.Duplex a
fromDuplex duplex = SEX.Duplex (unsafeCoerce duplex)