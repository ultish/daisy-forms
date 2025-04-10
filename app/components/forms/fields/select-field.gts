import Component from '@glimmer/component';

import Choices, { type EventChoice, type InputChoice } from 'choices.js';
import { modifier } from 'ember-modifier';
import { runTask } from 'ember-lifeline';
import { tracked } from '@glimmer/tracking';

export interface ChoiceAttributes {
  id: string;
  group?: string | undefined | null;
}

export interface Choice<T> {
  choice: T;
  selected: boolean;
}

export interface SelectFieldSignature<T extends ChoiceAttributes> {
  Args: {
    title: string;
    submitted?: boolean;
    choices: Choice<T>[];
    items?: InputChoice[];
    onAdd?: (detail: EventChoice) => void;
    onRemove?: (detail: EventChoice) => void;
    outerClass?: string;
    type?: string;
    required?: boolean;
    placeholder?: string;
  };
  Blocks: {
    option: [Choice<T>];
    validatorHint: [];
  };
}
export default class SelectField<T extends ChoiceAttributes> extends Component<
  SelectFieldSignature<T>
> {
  CHOICES_CLASS_NAMES = {
    containerOuter: ['choices', 'too-many-choices'],
    containerInner: ['choices__inner', 'custom_choices__inner'], // custom class
    input: ['choices__input'],
    inputCloned: ['choices__input--cloned'],
    list: ['choices__list', 'custom_choices__list'], // custom class, background
    listItems: ['choices__list--multiple'],
    listSingle: ['choices__list--single'],
    listDropdown: ['choices__list--dropdown'],
    item: ['choices__item', 'custom_item'],
    itemSelectable: ['choices__item--selectable'],
    itemDisabled: ['choices__item--disabled'],
    itemChoice: ['choices__item--choice'],
    description: ['choices__description'],
    placeholder: ['choices__placeholder'],
    group: ['choices__group'],
    groupHeading: ['choices__heading'],
    button: ['choices__button'],
    activeState: ['is-active'],
    focusState: ['is-focused'],
    openState: ['is-open'],
    disabledState: ['is-disabled'],
    highlightedState: ['is-highlighted'],
    selectedState: ['is-selected'],
    flippedState: ['is-flipped'],
    loadingState: ['is-loading'],
    notice: ['choices__notice'],
    addChoice: ['choices__item--selectable', 'add-choice'],
    noResults: ['has-no-results'],
    noChoices: ['has-no-choices'],
  };

  instance: Choices | undefined;
  ele: HTMLSelectElement | undefined;
  @tracked blurred = false;

  makeChoices = modifier((e: HTMLSelectElement) => {
    if (this.instance) {
      return;
    }

    this.ele = e;

    const outerClass = {
      containerOuter: [
        ...(this.args.outerClass?.split(' ') ?? []),
        ...this.CHOICES_CLASS_NAMES.containerOuter,
      ],
    };

    this.instance = new Choices(e, {
      items: this.args.items,
      removeItemButton: true,
      classNames: Object.assign(this.CHOICES_CLASS_NAMES, outerClass),
      callbackOnInit: () => {
        // TODO floating-ui ?? https://github.com/Choices-js/Choices/issues/504
        // this.choicesToggle = this.el.querySelector('.choices__inner');
        // this.choicesDropdown = this.el.querySelector(
        //   '.choices__list--dropdown',
        // );
      },
    });
    console.log('Choices instance created', this.instance);
    const addListener = (p: CustomEvent<EventChoice>) => {
      this.blurred = true;
      const { detail } = p;
      console.log('addItem', detail);

      const selected = this.args.choices.find(
        (c) => c.choice.id === detail.value,
      );
      if (selected) {
        selected.selected = true;
      }

      console.log('selected', selected);
      this.args.onAdd?.(detail);
    };
    const removeListener = (p: CustomEvent<EventChoice>) => {
      this.blurred = true;
      const { detail } = p;
      console.log('removeItem', p);
      const selected = this.args.choices.find(
        (c) => c.choice.id === detail.value,
      );
      if (selected) {
        selected.selected = false;
      }
      this.args.onRemove?.(detail);
    };

    this.ele?.addEventListener('addItem', addListener as EventListener);
    this.ele?.addEventListener('removeItem', removeListener as EventListener);

    return () => {
      this.ele?.removeEventListener('addItem', addListener as EventListener);
      this.ele?.removeEventListener(
        'removeItem',
        removeListener as EventListener,
      );
    };
  });

  get selected() {
    return this.args.choices.find((c) => c.selected);
  }

  // get value() {
  //   return this.instance ? this.instance.getValue(true) : undefined;
  // }

  choicesToggle: HTMLButtonElement | undefined;
  choicesDropdown: HTMLDivElement | undefined;

  // updatePosition() {
  //   computePosition(this.choicesToggle, this.choicesDropdown, {
  //     placement: 'bottom',
  //     middleware: [
  //       // Flip top/bottom position
  //       flip(),

  //       // Match toggle width
  //       size({
  //         apply({ rects, elements }) {
  //           Object.assign(elements.floating.style, {
  //             minWidth: `${rects.reference.width}px`,
  //           });
  //         },
  //       }),
  //     ],
  //     strategy: 'fixed',
  //   }).then(({ x, y }) => {
  //     Object.assign(this.choicesDropdown.style, {
  //       left: `${x}px`,
  //       top: `${y}px`,
  //       bottom: 'auto',
  //       position: 'fixed',
  //       width: 'auto',
  //     });
  //   });
  // }

  get choices() {
    const groups = this.args.choices.reduce(
      (acc, c) => {
        const { choice } = c;
        // Check if group already exists
        const group = choice.group ?? 'Ungrouped';
        if (!acc[group]) {
          acc[group] = { name: group, choices: [] };
        }
        // Push the choice to the corresponding group
        acc[group].choices.push(c);

        return acc;
      },
      {} as Record<string, { name: string; choices: Choice<T>[] }>,
    );

    runTask(this, () => this.instance?.refresh());
    const groupedChoices = Object.values(groups);

    return groupedChoices;
  }

  get type() {
    return this.args.type ?? 'text';
  }

  get required() {
    return this.args.required === true;
  }

  get checkValidation() {
    return this.blurred || this.args.submitted === true;
  }

  get inputCustomValid() {
    console.log(
      'inputCustomValid',
      this.checkValidation,
      this.required,
      this.selected,
    );
    if (this.checkValidation && this.required) {
      return this.selected ? 'custom-valid' : 'custom-invalid';
    } else {
      return '';
    }
  }

  <template>
    <fieldset class="fieldset form-control" ...attributes>
      <legend class="fieldset-legend">{{@title}}</legend>
      <label class="input w-full">
        <select
          {{this.makeChoices}}
          data-placeholder={{@placeholder}}
          aria-label="select choices"
        >
          {{#each this.choices as |group|}}
            <optgroup label="{{group.name}}">
              {{#each group.choices as |c|}}
                {{yield c to="option"}}
              {{/each}}
            </optgroup>
          {{/each}}
        </select>

        <div class="hidden validator {{this.inputCustomValid}}" />

        {{#if this.required}}
          <span class="label">Required</span>
        {{/if}}
      </label>
      <div class="validator-hint fieldset-label hidden">
        {{yield to="validatorHint"}}
      </div>
    </fieldset>
  </template>
}
