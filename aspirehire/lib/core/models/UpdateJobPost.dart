class UpdateJobPostRequest {
  final String? jobTitle;
  final String? jobDescription;
  final List<String>? requiredSkills;
  final String? location;
  final String? country;
  final int? salary;
  final String? jobPeriod;
  final String? experience;
  final String? applicationDeadline;

  UpdateJobPostRequest({
    this.jobTitle,
    this.jobDescription,
    this.requiredSkills,
    this.location,
    this.country,
    this.salary,
    this.jobPeriod,
    this.experience,
    this.applicationDeadline,
  });

  Map<String, dynamic> toJson() => {
    if (jobTitle != null) "jobTitle": jobTitle,
    if (jobDescription != null) "jobDescription": jobDescription,
    if (requiredSkills != null) "requiredSkills": requiredSkills,
    if (location != null) "location": location,
    if (country != null) "country": country,
    if (salary != null) "salary": salary,
    if (jobPeriod != null) "jobPeriod": jobPeriod,
    if (experience != null) "experience": experience,
    if (applicationDeadline != null) "applicationDeadline": applicationDeadline,
  };
}