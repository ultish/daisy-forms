// app/components/data-table.gts
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { debounce } from '@ember/runloop';
import { TabulatorFull as Tabulator } from 'tabulator-tables';
import { modifier } from 'ember-modifier';
import { on } from '@ember/modifier';

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

export default class DataTableBasic extends Component {
  @tracked searchValue = '';
  @tracked table: Tabulator | null = null;

  data: DataRow[] = Array.from({ length: 10000 }, (_, i) => ({
    id: i + 1,
    name: `User ${i}`,
    age: Math.floor(Math.random() * 60) + 20,
    city: ['New York', 'Los Angeles', 'Chicago', 'Houston'][
      Math.floor(Math.random() * 4)
    ],
    job: ['Engineer', 'Designer', 'Manager'][Math.floor(Math.random() * 3)],
    dept: ['IT', 'Creative', 'Sales'][Math.floor(Math.random() * 3)],
    salary: Math.floor(Math.random() * 100000) + 50000,
    active: Math.random() > 0.5,
    startDate: `202${Math.floor(Math.random() * 5)}-01-01`,
    notes: ['', 'Team lead', 'New hire'][Math.floor(Math.random() * 3)],
    email: `user${i}@example.com`,
    phone: `555-01${String(i).padStart(2, '0')}`,
  }));

  constructor(owner: unknown, args: {}) {
    super(owner, args);
    // No Worker initialization
  }

  willDestroy() {
    super.willDestroy();
    // No Worker to terminate
  }

  initTable = modifier((element: HTMLElement) => {
    this.table = new Tabulator(element, {
      height: '400px',
      renderVerticalBuffer: 100,
      data: this.data,
      columns: [
        { title: 'ID', field: 'id', visible: false },
        { title: 'Name', field: 'name' },
        { title: 'Age', field: 'age' },
        { title: 'City', field: 'city' },
        { title: 'Job', field: 'job' },
        { title: 'Dept', field: 'dept' },
        { title: 'Salary', field: 'salary' },
        { title: 'Active', field: 'active', formatter: 'tickCross' },
        { title: 'Start Date', field: 'startDate' },
        { title: 'Notes', field: 'notes' },
        { title: 'Email', field: 'email' },
        { title: 'Phone', field: 'phone' },
      ],
    });

    return () => {
      this.table?.destroy();
      this.table = null;
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

    // Filter directly on main thread
    const startFilter = performance.now();
    const searchValue = this.searchValue.toLowerCase();
    const filtered = searchValue
      ? this.data.filter((row) =>
          Object.values(row).some((value) =>
            value != null
              ? String(value).toLowerCase().includes(searchValue)
              : false,
          ),
        )
      : this.data;
    const endFilter = performance.now();

    // Update table
    const startRender = performance.now();
    this.table.setData(filtered);
    const endRender = performance.now();

    const filterDuration = endFilter - startFilter;
    const renderDuration = endRender - startRender;
    const totalDuration = endRender - startTotal;

    console.log(`Main Thread Filtering: ${filterDuration.toFixed(2)}ms`);
    console.log(`Render: ${renderDuration.toFixed(2)}ms`);
    console.log(`Total Filter-to-Render: ${totalDuration.toFixed(2)}ms`);
  }

  @action
  downloadCsv() {
    this.table?.download('csv', 'data.csv', {}, 'active');
  }

  <template>
    <label for="quick-filter">Quick Search:</label>
    <input
      type="text"
      id="quick-filter"
      placeholder="Search all columns..."
      value={{this.searchValue}}
      {{on "input" this.updateSearch}}
    />
    <button {{on "click" this.downloadCsv}}>Download CSV</button>
    <div {{this.initTable}}></div>
  </template>
}
