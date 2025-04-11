// public/workers/filter-worker.js
/**
 * @typedef {{ id: number; name: string; age: number; city: string; job: string; dept: string; salary: number; active: boolean; startDate: string; notes: string; email: string; phone: string }} DataRow
 * @typedef {{ data: DataRow[]; searchValue: string }} WorkerMessage
 */

/** @type {(e: MessageEvent<WorkerMessage>) => void} */
self.onmessage = function (e) {
  console.time('Worker Filtering');
  const { data, searchValue } = e.data;
  const filtered = searchValue
    ? data.filter((row) =>
        Object.values(row).some(
          (value) =>
            value != null &&
            value.toString().toLowerCase().includes(searchValue),
        ),
      )
    : data;
  console.timeEnd('Worker Filtering');
  self.postMessage(filtered);
};
