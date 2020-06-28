import assert from 'assert';
import { allAbsencesWithNames } from './absences';
import { everyItemContainsKey} from './api.spec'

describe('all_absences_with_names', async () => {
  describe('every absence has key', () => {
    [
      'admitterNote',
      'confirmedAt',
      'createdAt',
      'crewId',
      'endDate',
      'id',
      'memberNote',
      'rejectedAt',
      'startDate',
      'type',
      'userId',
      'employeeName'
    ].forEach((key) => {
      it(key, () => allAbsencesWithNames().then(everyItemContainsKey(key)));
    });
  });
});