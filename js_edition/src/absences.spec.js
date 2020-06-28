import assert from 'assert';
import { allAbsencesWithNames, employeeAbsenceStatus } from './absences';
import { members } from './api';
import { everyItemContainsKey} from './api.spec'

describe('allAbsencesWithNames', async () => {
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

describe('employeeAbsenceStatus', () => {
  it('prints the right message if employee is not absent', async () => {
    const allMembers = await members();
    const member = allMembers[0];
    const response = await employeeAbsenceStatus(member);

    assert(response, `${member.name} is NOT absent`);
  })

  const absenceData = async (member, type) => {
    const data = {
      admitterId: null,
      admitterNote: "",
      confirmedAt: "2016-12-12T18:03:55.000+01:00",
      createdAt: "2016-12-12T14:17:01.000+01:00",
      crewId: 352,
      endDate: "2021-01-13",
      id: 2351,
      memberNote: "",
      rejectedAt: null,
      startDate: "2017-01-13",
      type: type,
      userId: member.userId,
      employeeName: member.name
    };
    return [data];
  }

  describe('employee is on vacation', () => {
    it('prints the right message if employee is on vacation', async () => {
      const allMembers = await members();
      const member = allMembers[0];

      const response = await employeeAbsenceStatus(member, absenceData.bind(null, member, 'vacation'));
      assert.strictEqual(response, `${member.name} is on vacation`);
      
    })
  });

  describe('employee is sick', () => {
    it('prints the right message if employee is sick', async () => {
      const allMembers = await members();
      const member = allMembers[0];

      const response = await employeeAbsenceStatus(member, absenceData.bind(null, member, 'sickness'));
      assert.strictEqual(response, `${member.name} is sick`);
      
    })
  });
})