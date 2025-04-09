import { on } from '@ember/modifier';
import { action } from '@ember/object';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { modifier } from 'ember-modifier';
import { guidFor } from '@ember/object/internals';
import { htmlSafe } from '@ember/template';

export interface FormFieldsetCalendarComponentSignature {
  Args: {
    type?: string;
    required?: boolean;
    placeholder?: string;
  };
}
export default class FormFieldsetCalendarComponent extends Component<FormFieldsetCalendarComponentSignature> {
  get uniquePopoverId() {
    return `cally-popover-${guidFor(this)}`;
  }

  get uniqueAnchorName() {
    return `--cally-${guidFor(this)}`;
  }

  get anchorStyle() {
    return htmlSafe(`position-anchor: ${this.uniqueAnchorName}`);
  }

  get anchorName() {
    return htmlSafe(`anchor-name: ${this.uniqueAnchorName}`);
  }

  get type() {
    return this.args.type ?? 'text';
  }

  get required() {
    return this.args.required === true;
  }

  @tracked dateValue = ''; // Tracks the selected date
  @tracked isValid = true;
  @tracked blurred = false;

  @action
  updateDate(e: Event) {
    const target = e.target as HTMLInputElement | null;
    if (target) {
      this.blurred = true;
      this.dateValue = target.value;
      this.syncAndValidate();
    }
  }
  @action
  clearDate() {
    this.blurred = true;
    this.dateValue = ''; // Clear the date
    this.syncAndValidate();
  }

  inputElement: HTMLInputElement | undefined;

  doValidate = modifier((e: HTMLElement) => {
    if (e instanceof HTMLInputElement) {
      this.inputElement = e;
    }
  });

  @action
  syncAndValidate() {
    if (this.inputElement) {
      this.inputElement.value = this.dateValue; // Sync value
      // Simulate user interaction
      this.inputElement.focus();
      this.inputElement.dispatchEvent(new Event('input', { bubbles: true }));
      this.inputElement.blur();
      // Force form validation if within a form
      // const form = this.inputElement.closest('form');
      // if (form) {
      //   form.reportValidity(); // Trigger form-wide validation
      // }
      this.isValid = this.inputElement.checkValidity();
      console.log(
        'Input validity:',
        this.isValid,
        'Value:',
        this.dateValue,
        'User-invalid:',
        this.inputElement.matches(':user-invalid'),
      );
    }
  }

  get value() {
    if (this.dateValue) {
      return this.dateValue;
    } else {
      return this.args.placeholder;
    }
  }

  get inputCustomValid() {
    if (this.blurred && this.required) {
      return this.isValid ? 'custom-valid' : 'custom-invalid';
    } else {
      return '';
    }
  }

  <template>
    <button
      type="button"
      popovertarget={{this.uniquePopoverId}}
      class="w-full h-full text-left"
      style={{this.anchorName}}
    >
      {{this.value}}
    </button>
    {{#if this.dateValue}}
      <button
        type="button"
        class="absolute top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700
          {{if this.required 'right-22' 'right-2'}}"
        {{on "click" this.clearDate}}
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-5 w-5"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path
            fill-rule="evenodd"
            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
            clip-rule="evenodd"
          />
        </svg>
      </button>
    {{/if}}
    <div
      popover
      id={{this.uniquePopoverId}}
      class="dropdown bg-base-100 rounded-box shadow-lg"
      style={{this.anchorStyle}}
    >

      <calendar-date
        class="cally"
        value={{this.dateValue}}
        {{on "change" this.updateDate}}
      >
        <svg
          aria-label="Previous"
          class="fill-current size-4"
          slot="previous"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
        ><path fill="currentColor" d="M15.75 19.5 8.25 12l7.5-7.5"></path></svg>
        <svg
          aria-label="Next"
          class="fill-current size-4"
          slot="next"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
        ><path fill="currentColor" d="m8.25 4.5 7.5 7.5-7.5 7.5"></path></svg>
        <calendar-month></calendar-month>
      </calendar-date>
    </div>

    <input
      type="text"
      class="validator w-full hidden {{this.inputCustomValid}}"
      required
      placeholder="Select a date"
      value={{this.dateValue}}
      {{this.doValidate}}
    />
    {{#if this.required}}
      <span class="label">Required</span>
    {{/if}}
  </template>
}
