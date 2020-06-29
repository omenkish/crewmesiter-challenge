import moment from 'moment';
import ical from 'ical-generator';
import { writeFileSync } from 'fs';

import { absences, members } from './api';

export const allAbsencesWithNames = async () => {
  try {
    let allAbsences = await absences();
    let transformedAbsences = [];

    for (let absence of allAbsences){
      let member = await getMemberById(absence.userId);
      absence.employeeName = member.name;
      transformedAbsences.push(absence);
    }

    return transformedAbsences;
  } catch (error) {
    throw new Error(error);
  }
};

export const toIcal = async () => {
  try {
    const all_absences = await allAbsencesWithNames();
    const events = [];

    for (let absence of all_absences) {
      const event = {
        start: moment(absence.startDate),
        end: moment(absence.endDate),
        timestamp: moment(),
        description: `${absence.employeeName} is absent due to ${absence.type}.`,
        summary: `${absence.employeeName}'s absence details`,
        organizer: 'Manager <mail@example.com>'
      };

      events.push(event);
    }
    return ical({
      domain: 'mydomain.net',
      prodId: '//mydomain.com//ical-generator//EN',
      events
    }).toString();
  } catch (error) {
    throw new Error(error);
  }
};

export const writeIcalDataToFile = async (filename = 'absences', data = toIcal) => {
  try {
    const absences = await  data();
    writeFileSync(`${__dirname}/${filename}.ics`, absences);
  } catch (error) {
    throw new Error(error)
  }

};

export const employeeAbsenceStatus = async (employee, absences = allAbsencesWithNames) => {
  const status = {
    vacation: (member) => `${member} is on vacation`,
    sickness: (member) => `${member} is sick`,
    default: (member) => `${member} is currently NOT absent`,
  };

  try {
    const allAbsences = await absences();
    const absence = employeeAbsence(employee.userId, allAbsences);

    // Return absence type if employee has any absence or null otherwise
    const type = absence && absence.type || null;

    return status[type || 'default'](employee.name)
  } catch (error) {
    throw new Error(error);
  }
};

const getMemberById = async (id) => {
  try {
    let allMembers = await members();
    return allMembers.find((member) => member.userId === id);
  } catch (error) {
    throw new Error(error);
  }
};

const employeeAbsences = (employeeId, absences) => {

  return absences.filter((absence) => absence.userId === employeeId);
};

const employeeAbsence = (employeeId, absences) => {
  try {
    const allEmployeeAbsences = employeeAbsences(employeeId, absences);

    return allEmployeeAbsences.find((absence) => moment(absence.endDate) >= new Date());
  } catch (error) {
    throw new Error(error);
  }
};
