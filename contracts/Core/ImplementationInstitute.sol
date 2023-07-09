//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";


contract ImplementationInstitute is ERC721URIStorageUpgradeable {

    uint degreeId; // No. of degrees minted.

    address public admin; // Admin for the Institute implementation.

    struct SemesterCredential{
        uint8 semesterNumber;
        uint8 totalSubjects;
        bytes8[] subjectCodes;
        uint8[] subjectMarks; 
        bool isPassed; 
    }

    struct DegreeDetails{
        uint16 programmeCode;
        address ownerIdentity;
        uint256 issueTime;
    }

    mapping(address=>mapping(uint=> mapping(uint=>SemesterCredential))) MarksheetCredential; // address => programmeCode => semesterNo

    mapping(bytes8=>string) public subjectCode; // subject Code => Subject name.

    mapping(uint16=>uint8) public programmeSemestersRequired; // Programme code => Semesters required to get SBT Degree issued.

    mapping(address=>bool) public isEnrolled;

    mapping(address=>uint16) public currentProgrammeCode; // student identity => Current program

    mapping(address=>uint8) public currentSemester;

    mapping(uint256=>DegreeDetails) public CredentialDetails; // Degree ID => Degree Details.

    bool public mintingEnabled;

    modifier onlyAdmin() {
        require(msg.sender==admin,"You are not the admin!");
        _;
    }

    function init(string memory _entityName, address _portalAdmin) external initializer{
        require(_portalAdmin!=address(0),"Zero address.");
        __ERC721_init_unchained(_entityName, _entityName);
        admin = _portalAdmin;
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual override{
        bool letTransfer = false;
        require(letTransfer,"You are not allowed to transfer a credential.");
    }

    function enrollStudent(address _identity, uint16 _programme) external onlyAdmin {
        isEnrolled[_identity] = true;
        currentProgrammeCode[_identity]=_programme;
        currentSemester[_identity] = 1;
    }

    function batchIssueSemesterCredential(address[] memory _identities,
    uint8 _semesterNumber, uint _programmeCode,
    SemesterCredential[] memory _semesterCredential) 
    external onlyAdmin returns(bool){
        uint totalIdentities  = _identities.length;
        bool success;
        for(uint i=0;i<totalIdentities;i++){
            MarksheetCredential[_identities[i]][_programmeCode][_semesterNumber] = _semesterCredential[i];
            if(_semesterCredential[i].isPassed == true){
                currentSemester[_identities[i]] = _semesterNumber + 1;
            }
            if(i==totalIdentities-1){
                success = true;
            }
        }
        return success;
    }

    function checkSemesterCredential(address _identity,uint _programmeCode, uint _semesterNumber) external view returns(SemesterCredential memory) {
        return MarksheetCredential[_identity][_programmeCode][_semesterNumber];
    }

    function mintFinalCredential(address _identity,uint _programmeCode) external {
        require(currentSemester[_identity]==programmeSemestersRequired[currentProgrammeCode[_identity]],"You have not completed all semesters!");
        require(MarksheetCredential[_identity][_programmeCode][programmeSemestersRequired[currentProgrammeCode[_identity]]].isPassed,"Not passed yet!");
        require(mintingEnabled,"Minting is disabled!");
        degreeId++;
        _safeMint(_identity, degreeId);
        CredentialDetails[degreeId].programmeCode = currentProgrammeCode[_identity];
        CredentialDetails[degreeId].ownerIdentity = _identity;
        CredentialDetails[degreeId].issueTime = block.timestamp;
    }










}