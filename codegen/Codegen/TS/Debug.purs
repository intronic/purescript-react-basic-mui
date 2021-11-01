module Codegen.TS.Debug where

import Prelude
import Data.Functor.Mu (Mu(..)) as Mu
import Data.Map (lookup) as Map
import Data.Map.Internal (keys) as Map.Internal
import Data.Maybe (Maybe(..))
import Debug (class DebugWarning, traceM)
import Matryoshka (cata)
import ReadDTS.Instantiation (Type, TypeF(..)) as ReadDTS.Instantiation
import ReadDTS.Instantiation.Pretty (pprint) as ReadDTS.Instantiation.Pretty
import ReadDTS.Instantiation.Pretty (pprintTypeName)

data TraceMode
  = TypeNameOnly
  | FullType

-- | Traces a value of `Instntiation.Object` property
tracePropType :: forall m. DebugWarning => Monad m => TraceMode -> ReadDTS.Instantiation.Type -> String -> m Unit
tracePropType traceMode (Mu.In (ReadDTS.Instantiation.Object n props)) prop = case Map.lookup prop props of
  Nothing -> traceM $ "Missing prop: " <> prop <> "\nAvailable props: " <> show (Map.Internal.keys props)
  Just p ->
    traceM
      $ case traceMode of
          FullType -> ReadDTS.Instantiation.Pretty.pprint p.type
          TypeNameOnly -> cata pprintTypeName p.type
tracePropType _ t _ = traceM $ "Non object type passed: " <> cata pprintTypeName t

traceType :: forall m. DebugWarning => Monad m => TraceMode -> ReadDTS.Instantiation.Type -> m Unit
traceType traceMode t =
  traceM
    $ case traceMode of
        FullType -> ReadDTS.Instantiation.Pretty.pprint t
        TypeNameOnly -> cata pprintTypeName t

traceIntersectionTypes :: ∀ m. DebugWarning => Monad m => TraceMode -> ReadDTS.Instantiation.Type -> m Unit
traceIntersectionTypes traceMode (Mu.In (ReadDTS.Instantiation.Intersection a b)) = do
  traceType traceMode a
  traceIntersectionTypes traceMode b
traceIntersectionTypes traceMode t = traceType traceMode t
