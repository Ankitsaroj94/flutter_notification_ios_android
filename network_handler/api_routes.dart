import '../../config/env.dart';

abstract class ApiRoutes {
  static String get base => Env.baseUrl;
  static String get loginWithPassword => '/Authentication/Login';
  static String get academicResourceDetail => 'SMT/AcademicResource';
  static String get circularDetail => 'SMT/CircularNotice';
  static String get assignmentDetail => 'SMT/AssignmentDetails';
  static String get calender => 'SMT/Calendar';
  static String get staffCtc => 'SMT/StaffCTC';
  static String get notificationsList => 'SMT/NotificationsList';
  static String get generateOtp => 'Authentication/GenerateLoginOTP';
  static String get verifyOtp => 'Authentication/VerifyLoginOTP';
  static String get announcementDashBoard => 'SMT/AnnouncementDashBoard';
  static String get announcementsList => 'SMT/AnnouncementsList';
  static String get announcementDetails => 'SMT/AnnoucementDetails';
  static String get postAnnouncement => 'SMT/PostAnnouncement';
  static String get staffLeaveHomepage => 'SMT/StaffLeaveHomepage';
  static String get staffLeaveStatusList => 'SMT/StaffLeaveStatusList';
  static String get staffLeaveRequestDetail => 'SMT/StaffLeaveRequestDetail';
  static String get staffLeaveRequestApplication =>
      'SMT/StaffLeaveRequestApplication';
  static String get leaveApproval => 'SMT/LeaveApproval';

  static String get parentCommunication => 'SMT/ParentCommunication';
  static String get staffProfileDetails => 'SMT/StaffProfile';
  static String get staffStrengthDetails => 'SMT/StaffStrength';
  static String get eventList => 'SMT/EventsList';
  static String get eventDetails => 'SMT/EventDetails';
  static String get healthRoomVisits => 'SMT/HealthRoomVisits';
  static String get yearPlanAnalysis => 'SMT/YearPlanAnalysis';
  static String get studentProfile => 'SMT/StudentProfile';
  static String get studentAcademicPerformance =>
      'SMT/StudentAcademicPerformance';
  static String get studentPersonalityTraits => 'SMT/StudentPersonalityTraits';
  static String get studentParticipatedEvents =>
      'SMT/StudentParticipatedEvents';
  static String get attendanceLog => 'SMT/AttendanceLog';

  static String get markComposition => 'SMT/MarkComposition';
  static String get rollOfHonor => 'SMT/RollOfHonor';

  static String get dashBoard => '/SMT/SMTDashboard';
  static String get directoryList => 'SMT/SchoolDirectory';
  static String get studentAttendance => 'SMT/StudentAttendance';
  static String get staffAttendance => 'SMT/StaffAttendance';
  static String get librarySummary => 'SMT/Library';
  static String get assignmentList => 'SMT/AssignmentsList';
  static String get circularNoticesList => 'SMT/CircularNoticesList';
  static String get academicResources => 'SMT/AcademicResourcesList';
  static String get birthdayList => 'SMT/BirthdayList';
  static String get siteList => 'SMT/SiteList';
  static String get classList => 'SMT/ClassList';
  static String get formList => 'SMT/FormList';
  static String get staffList => 'SMT/StaffList';
  static String get staffPaOut => 'SMT/StaffPayout';
  static String get subjectList => 'SMT/SubjectList';
  static String get houseList => 'SMT/HouseList';
  static String get birthDayHistory => 'SMT/BirthdayHistory';
  static String get browseMenu => 'SMT/BrowseMenuList';
  static String get staffPaySlip => 'SMT/PaySlipList';
  static String get form16List => 'SMT/Form16List';
  static String get paySlipDetail => 'SMT/PaySlipDetail';
  static String get form16Detail => 'SMT/Form16Detail';
  static String get postBirthdayWish => 'SMT/PostWish';
  static String get chatList => 'SMT/ChatList';
  static String get chatHistory => 'SMT/ChatHistory';
  static String get sendMessage => 'SMT/PostMessageToStudents';
  static String get studentCollectionLedger => 'SMT/StudentCollectionLedger';
  static String get studentCollectionSummary => 'SMT/StudentCollectionSummary';
  static String get staffCategoryList => 'SMT/StaffCategoryList';
  static String get yearList => 'SMT/AcademicYearList';
  static String get forgotPassword => 'Authentication/ForgotPassword';
  static String get verifyUserPassword => 'Authentication/VerifyUserPassword';
  static String get resetUserPassword => 'Authentication/ResetUserPassword';
  static String get teacherPerformance => 'SMT/PerformanceTrends';
}
