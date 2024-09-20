import type { FancyContainerSpanOptions, SpanBuilderInstall, TextBuilderOptions } from '../index';
import { spanBuilder } from './span';

@Builder
export function containerSpanBuilder($$: TextBuilderOptions, install: SpanBuilderInstall) {
  ContainerSpan() {
    spanBuilder(
      {
        node: $$.node,
        index: $$.index,
        parentNode: $$.parentNode
      },
      {
        defaultArtUI: install.defaultArtUI,
        onLinkPress: install.onLinkPress
      }
    );
  }
  .fancyContainerSpan($$.node.artUIStyleObject || $$.parentNode?.artUIStyleObject)
}

@Extend(ContainerSpan)
function fancyContainerSpan($$: FancyContainerSpanOptions = {}) {
  .textBackgroundStyle({ color: $$.backgroundColor, radius: $$.borderRadius as Dimension | BorderRadiuses })
}
