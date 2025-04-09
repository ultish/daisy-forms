// import Component from '@glimmer/component';
import type { TOC } from '@ember/component/template-only';
import FormGroupComponent from './group';
import { hash } from '@ember/helper';
import type { ComponentLike } from '@glint/template';

interface Signature {
  Args: undefined;
  Blocks: {
    default: [
      {
        group: ComponentLike<FormGroupComponent>;
      },
    ];
    buttonBar: [];
  };
}
// export default class FormComponent extends Component<Signature> {
<template>
  <form>
    <div
      class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      ...attributes
    >
      {{yield (hash group=FormGroupComponent)}}
    </div>
    <div class="mt-6 flex items-center justify-end gap-2">
      {{#if (has-block "buttonBar")}}
        {{yield to="buttonBar"}}
      {{else}}
        {{! can provide a default button for you }}
        <button type="submit" class="btn btn-sm btn-primary">
          Save
        </button>
      {{/if}}
    </div>
  </form>
</template> satisfies TOC<Signature>;
// }
