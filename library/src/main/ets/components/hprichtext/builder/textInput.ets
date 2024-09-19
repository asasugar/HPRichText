import type { Attr, NodeInfo } from '../../../common/types';
import type { FancyTextInputOptions } from '../index';

@Builder
export function textInputBuilder(item: NodeInfo) {
  TextInput({
    text: item?.attr?.value,
    placeholder: item?.attr?.placeholder
  })
    .fancyTextInput(item?.artUIStyleObject, item?.attr);
}

@Extend(TextInput)
function fancyTextInput($$: FancyTextInputOptions = { fontSize: 14, fontColor: Color.Black }, attrs: Attr = {}) {
  .width($$.width)
  .height($$.height)
  .type(
    attrs.type === 'number' ? InputType?.Number :
      attrs.type === 'tel' ? InputType?.PhoneNumber :
        attrs.type === 'password' ? InputType?.Password :
          attrs.type === 'email' ? InputType?.Email :
            InputType?.Normal
  )
  .placeholderColor(Color?.Grey)
  .placeholderFont({ size: 14, weight: 400 })
  .fontSize($$.fontSize)
  .fontColor($$.fontColor)
  .maxLength(attrs.maxlength)
  .inputFilter(attrs.pattern, (e) => {
    // console.log(JSON.stringify(e))
  })
}
