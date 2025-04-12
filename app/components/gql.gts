// app/components/data-table.gts
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { debounce } from '@ember/runloop';
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import { modifier } from 'ember-modifier';
import { on } from '@ember/modifier';
import { useQuery } from 'glimmer-apollo';
import { gql } from '@apollo/client/core';
import {
  type SubscriptionPersonUpdatedArgs,
  type Person,
  type QueryPersonArgs,
} from 'ember-6-3/graphql/types/graphql';
import { useSubscription } from 'glimmer-apollo';
import objectScan from 'object-scan';

interface ColumnScan {
  property: string;
  title: string;
  field: string;
}
export type PersonQuery = {
  __typename?: 'Query';
  person: Person;
};
export type PersonUpdatedSubscription = {
  __typename?: 'Subscription';
  personUpdated: Person;
};

const ON_PERSON_UPDATED = gql`
  subscription OnPersonUpdated ($id: ID!) {
    personUpdated(id: $id) {
      id
      name
      age
      pets {
        id
        name
        species
        toys {
          id
          name
          type
        }
      }
    }
  }
`;
const GET_USER = gql`
  query person($id: ID!) {
    person(id: $id) {
      id
      name
      age
      pets {
        id
        name
      }
    }
  }
`;

const GET_USER_PETS = gql`
  query person($id: ID!) {
    person(id: $id) {
      id
      pets {
        id
        name
        species
        toys {
          id
          name
          type
        }
      }
    }
  }
`;

interface DataRow {
  id: number;
  name?: string;
  age?: number;
  city?: string;
  job?: string;
  dept?: string;
  salary?: number;
  active?: boolean;
  startDate?: string;
  notes?: string;
  email?: string;
  phone?: string;
}

interface WorkerMessage {
  data: DataRow[];
  searchValue: string;
}
interface WorkerResponse {
  filtered: DataRow[];
  duration: number;
}
export default class Gql extends Component {
  @tracked searchValue = '';
  @tracked table: Tabulator | undefined;
  worker: Worker;

  constructor(owner: unknown, args: {}) {
    super(owner, args);
    // No preprocessing needed
    this.worker = new Worker('/workers/filter-worker.js');
  }

  willDestroy() {
    super.willDestroy();
    this.worker.terminate();
  }

  initTable = modifier(async (element: HTMLElement) => {
    // if (this.table !== undefined) {
    //   return;
    console.log('INIT TABL');
    // }

    // force-disconnect from auto-tracking
    await Promise.resolve();

    this.table = new Tabulator(element, {
      height: '400px', // Virtual DOM
      renderVerticalBuffer: 100, // Buffer in pixels
      data: this.personPetsFlat,
      columns: this.petColumns,
    });

    return () => {
      // this.table?.destroy();
      // this.table = null;
    };
  });

  @action
  updateSearch(event: Event) {
    const input = event.target as HTMLInputElement;
    this.searchValue = input.value;
    debounce(this, this.applyFilter, 250);
  }

  applyFilter() {
    if (!this.table) return;
    const startTotal = performance.now();
    const searchValue = this.searchValue.toLowerCase();
    const message: WorkerMessage = { data: this.data, searchValue };
    this.worker.postMessage(message);
    this.worker.onmessage = (event: MessageEvent<WorkerResponse>) => {
      // this.worker.onmessage = (event: MessageEvent<DataRow[]>) => {
      const startRender = performance.now();
      this.table!.setData(event.data.filtered);
      const endRender = performance.now();

      const workerDuration = event.data.duration;
      const transferAndRender = endRender - startRender;
      const totalDuration = endRender - startTotal;

      console.log(`Worker Filtering: ${workerDuration.toFixed(2)}ms`);
      console.log(
        `Tabulator Transfer + Render: ${transferAndRender.toFixed(2)}ms`,
      );
      console.log(`Total Filter-to-Render: ${totalDuration.toFixed(2)}ms`);
    };
  }

  @action
  downloadCsv() {
    this.table?.download('csv', 'data.csv', {}, 'active');
  }

  columns: ColumnScan[] = [
    {
      property: 'name',
      title: 'Name',
      field: 'name',
    },
    {
      property: 'age',
      title: 'Age',
      field: 'age',
    },
    {
      property: 'pets.name', // Handling array of objects
      title: 'Pets',
      field: 'pets',
    },
  ];

  petColumns: ColumnScan[] = [
    {
      property: 'name',
      title: 'Name',
      field: 'name',
    },
    {
      property: 'species',
      title: 'Species',
      field: 'species',
    },
    {
      property: 'toys.name', // Handling array of objects
      title: 'Toys',
      field: 'toys',
    },
  ];

  user = useQuery<PersonQuery, QueryPersonArgs>(this, () => [
    GET_USER,
    { variables: { id: '1' } },
  ]);

  pets = useQuery<PersonQuery, QueryPersonArgs>(this, () => [
    GET_USER_PETS,
    { variables: { id: '1' } },
  ]);

  get personDetails() {
    return this.user.data?.person?.name;
  }

  get personPets() {
    return this.pets.data?.person.pets;
  }

  get personPetsFlat() {
    const data = this.personPets?.map((d) => {
      return this.petColumns.reduce(
        (row, col) => {
          // object-scan has many cool functions to flatten out deeply nested objects!
          const values = objectScan([col['property']], {
            useArraySelector: false,
            rtn: 'value', // Extract values directly
          })(d);

          // store the value in the row object using the field name
          const key = col['field'];
          row[key] =
            Array.isArray(values) && values.length > 0
              ? values.sort().join(', ')
              : '';
          return row;
        },
        {} as Record<string, string>,
      );
    });

    // This works with subscription udpates. i can change name of a pet for a person and it re-renders the table!
    if (this.table?.initialized) {
      this.table?.setData(data);
    }

    return data;
  }

  get hasPets() {
    return (this.personPetsFlat ?? []).length > 0;
  }

  personSub = useSubscription<
    PersonUpdatedSubscription,
    SubscriptionPersonUpdatedArgs
  >(this, () => [
    ON_PERSON_UPDATED,
    {
      variables: { id: '1' }, // Replace with the actual ID
      /* options */
    },
  ]);

  /**
   * TODO testing
   * - 2 queries (watchQuery)
   * - 1 subscription on Person
   * - use object scan
   * - display them in tabulator,
   * - update person name
   * - update pet name
   * - do tabulator tables update?
   */

  /**
   * what happens here is:
   * 1. query persons pets
   * 2. flatten pets with objectscan
   * 3. display on tabulator
   * 4. update pet name via gql
   * 5. subscribe to personUpdated is pushed down, updating caches. the pet is included so the pet cache gets udpated
   * 6. as useQuery uses apollo's watchQuery, it reacts to apollo cache changes.
   * 7. the apollo cache changes due to the subscription inlcuding the pet and it has IDs
   * 8. the get personPetsFlat auto tracks and reacts which re-sets tabulator.setData
   */

  <template>
    <style></style>

    {{this.personPetsFlat.length}}
    <label for="quick-filter">Quick Search:</label>
    <input
      type="text"
      id="quick-filter"
      placeholder="Search all columns..."
      value={{this.searchValue}}
      {{on "input" this.updateSearch}}
    />
    <button {{on "click" this.downloadCsv}}>Download CSV</button>

    {{!-- {{#if this.hasPets}} --}}
    <div class="my-tabulator" {{this.initTable}}></div>
    {{!-- {{/if}} --}}

    {{#if this.personSub.loading}}
      Connecting..
    {{else if this.personSub.error}}
      Error!:
      {{this.personSub.error.message}}
    {{else}}
      <div>
        New Message:
        {{this.personSub.data.personUpdated.id}}
      </div>
    {{/if}}
  </template>
}
