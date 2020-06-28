import moment from 'moment';
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
}

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
}

const getMemberById = async (id) => {
  try {
    let allMembers = await members();
    const employee = allMembers.find((member) => member.userId === id)
    return employee
  } catch (error) {
    throw new Error(error);
  }

}

const employeeAbsences = (employeeId, absences) => {
  
  return absences.filter((absence) => absence.userId === employeeId);
}

const employeeAbsence = (employeeId, absences) => {
  try {
    const allEmployeeAbsences = employeeAbsences(employeeId, absences);

    return allEmployeeAbsences.find((absence) => moment(absence.endDate) >= new Date());
  } catch (error) {
    throw new Error(error);
  }
  
}
