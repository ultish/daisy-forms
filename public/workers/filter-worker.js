// public/workers/filter-worker.js
/**
 * @typedef {{ id: number; name: string; age: number; city: string; job: string; dept: string; salary: number; active: boolean; startDate: string; notes: string; email: string; phone: string }} DataRow
 * @typedef {{ data: DataRow[]; searchValue: string }} WorkerMessage
 * @typedef {{ filtered: DataRow[]; duration: number }} WorkerResponse
 */

/** @type {(e: MessageEvent<WorkerMessage>) => void} */
self.onmessage = function (e) {
  const start = performance.now();
  const { data, searchValue } = e.data;
  const filtered = searchValue
    ? data.filter((row) =>
        Object.values(row).some((value) =>
          value != null
            ? String(value).toLowerCase().includes(searchValue)
            : false,
        ),
      )
    : data;
  const end = performance.now();
  /** @type {WorkerResponse} */
  const response = { filtered, duration: end - start };
  self.postMessage(response);
};
