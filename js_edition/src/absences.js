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

const getMemberById = async (id) => {
  
  try {
    let allMembers = await members();
    let employee = allMembers.find((member) => member.userId === id) 
    return employee
  } catch (error) {
    console.log('ERROR:::', error);
  }

}
