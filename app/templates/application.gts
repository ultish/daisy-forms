import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';

import FormComponent from 'ember-6-3/components/forms/layout/form';
import FormFieldSetComponent from 'ember-6-3/components/forms/fields/fieldsets/fieldset.gts';
import FormFieldsetInputComponent from 'ember-6-3/components/forms/fields/fieldsets/input';
import { on } from '@ember/modifier';
import InputField from 'ember-6-3/components/forms/fields/input-field';
import SelectField from 'ember-6-3/components/forms/fields/select-field';
import DataTable from 'ember-6-3/components/data-table';

class ApplicationRouteTemplate extends Component {
  get choices() {
    return [
      {
        selected: false,
        choice: {
          id: '1',
          name: 'Charge Code 1',
          group: null,
        },
      },
      {
        selected: false,
        choice: {
          id: '2',
          name: 'Charge Code 2',
          group: null,
        },
      },
    ];
  }
  <template>
    {{pageTitle "Ember63"}}
    <header class="bg-amber-400 p-6">
      <label class="swap swap-rotate">
        <input type="checkbox" class="theme-controller" value="dark" />

        <svg
          class="swap-off h-10 w-10 fill-current"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
        >
          <path
            d="M5.64,17l-.71.71a1,1,0,0,0,0,1.41,1,1,0,0,0,1.41,0l.71-.71A1,1,0,0,0,5.64,17ZM5,12a1,1,0,0,0-1-1H3a1,1,0,0,0,0,2H4A1,1,0,0,0,5,12Zm7-7a1,1,0,0,0,1-1V3a1,1,0,0,0-2,0V4A1,1,0,0,0,12,5ZM5.64,7.05a1,1,0,0,0,.7.29,1,1,0,0,0,.71-.29,1,1,0,0,0,0-1.41l-.71-.71A1,1,0,0,0,4.93,6.34Zm12,.29a1,1,0,0,0,.7-.29l.71-.71a1,1,0,1,0-1.41-1.41L17,5.64a1,1,0,0,0,0,1.41A1,1,0,0,0,17.66,7.34ZM21,11H20a1,1,0,0,0,0,2h1a1,1,0,0,0,0-2Zm-9,8a1,1,0,0,0-1,1v1a1,1,0,0,0,2,0V20A1,1,0,0,0,12,19ZM18.36,17A1,1,0,0,0,17,18.36l.71.71a1,1,0,0,0,1.41,0,1,1,0,0,0,0-1.41ZM12,6.5A5.5,5.5,0,1,0,17.5,12,5.51,5.51,0,0,0,12,6.5Zm0,9A3.5,3.5,0,1,1,15.5,12,3.5,3.5,0,0,1,12,15.5Z"
          />
        </svg>

        <svg
          class="swap-on h-10 w-10 fill-current"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
        >
          <path
            d="M21.64,13a1,1,0,0,0-1.05-.14,8.05,8.05,0,0,1-3.37.73A8.15,8.15,0,0,1,9.08,5.49a8.59,8.59,0,0,1,.25-2A1,1,0,0,0,8,2.36,10.14,10.14,0,1,0,22,14.05,1,1,0,0,0,21.64,13Zm-9.5,6.69A8.14,8.14,0,0,1,7.08,5.22v.27A10.15,10.15,0,0,0,17.22,15.63a9.79,9.79,0,0,0,2.1-.22A8.11,8.11,0,0,1,12.14,19.73Z"
          />
        </svg>
      </label>
      <h2 id="title" class="inline-block">Welcome to Ember</h2>
    </header>
    <main class="w-full p-8">

      <DataTable />
      <div class="skeleton h-32 w-32"></div>

      <h1>Form Component</h1>
      <FormComponent>
        <:form as |f|>
          <f.group>
            <:header>
              Group 1
            </:header>
            <:description>
              A description of the group
            </:description>
            <:rows as |row|>
              <InputField
                @title="First Name"
                @submitted={{row.submitted}}
                @required={{true}}
                class="col-span-4"
              >
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </InputField>

              <SelectField
                @title="Options"
                @submitted={{row.submitted}}
                @choices={{this.choices}}
                @required={{true}}
                class="col-span-4"
              >
                <:option as |item|>
                  <option
                    selected={{if item.selected "selected"}}
                    value={{item.choice.id}}
                  >
                    {{item.choice.name}}
                  </option>
                </:option>
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </SelectField>

              {{! <g.row> }}
              <FormFieldSetComponent
                @title="Username"
                @submitted={{row.submitted}}
                class="col-span-4"
              >
                <:field as |x|>
                  <x.input @required={{true}} @placeholder="Who are you?" />
                </:field>
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </FormFieldSetComponent>
              <FormFieldSetComponent
                @title="Password"
                @submitted={{row.submitted}}
                class="col-span-4"
              >
                <:field>
                  <FormFieldsetInputComponent
                    @type="password"
                    @required={{true}}
                    minlength="8"
                    pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
                    class="col-span-4"
                  />
                </:field>
                <:validatorHint>
                  Must be more than 8 characters, including
                  <br />At least one number
                  <br />At least one lowercase letter
                  <br />At least one uppercase letter
                </:validatorHint>
              </FormFieldSetComponent>
              {{! </g.row> }}
            </:rows>
          </f.group>

          <f.group>
            <:header>
              Group 2
            </:header>
            <:description>
              A description of the group
            </:description>
            <:rows as |row|>
              {{! <g.row> }}
              <FormFieldSetComponent
                @title="Start Date"
                @submitted={{row.submitted}}
                class="col-span-3"
              >
                <:field as |x|>
                  <x.calendar @required={{true}} />
                </:field>
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </FormFieldSetComponent>

              <FormFieldSetComponent
                @title="End Date"
                @submitted={{row.submitted}}
                class="col-span-3"
              >
                <:field as |x|>
                  <x.calendar @required={{false}} />
                </:field>
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </FormFieldSetComponent>

              <FormFieldSetComponent
                @title="Options"
                @submitted={{row.submitted}}
                class="col-span-4"
              >
                <:field as |x|>
                  <x.select
                    @choices={{this.choices}}
                    @required={{true}}
                    as |item|
                  >
                    <option
                      selected={{if item.selected "selected"}}
                      value={{item.choice.id}}
                    >
                      {{item.choice.name}}
                    </option>
                  </x.select>
                </:field>
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </FormFieldSetComponent>

              <FormFieldSetComponent
                @title="Options"
                @submitted={{row.submitted}}
                class="col-span-4"
              >
                <:field as |x|>
                  <x.select
                    @choices={{this.choices}}
                    @required={{false}}
                    as |item|
                  >
                    <option
                      selected={{if item.selected "selected"}}
                      value={{item.choice.id}}
                    >
                      {{item.choice.name}}
                    </option>
                  </x.select>
                </:field>
                <:validatorHint>
                  Required Field
                </:validatorHint>
              </FormFieldSetComponent>
              {{! </g.row> }}
            </:rows>
          </f.group>
        </:form>
        <:buttonBar as |bb|>
          <button type="button" class="btn btn-sm btn-ghost">
            Cancel
          </button>
          <button
            type="submit"
            class="btn btn-sm btn-primary"
            {{on "click" bb.handleSubmit}}
          >
            Save
          </button>
        </:buttonBar>
      </FormComponent>

      {{outlet}}
    </main>
  </template>
}
export default Route(ApplicationRouteTemplate);
