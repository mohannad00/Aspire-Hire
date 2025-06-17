class Profile {
  final String profileId;
  final String username;
  final String email;
  final String phone;
  final String? role;
  final ProfilePicture? profilePicture;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final List<Skill> skills;
  final List<String> friendRequestsSentIds;
  final List<Education> education;
  final List<Experience> experience;
  final List<dynamic> jobApplications;
  final List<dynamic> jobPosts;
  final String? github;
  final String? twitter;

  Profile({
    required this.profileId,
    required this.username,
    required this.email,
    required this.phone,
    this.role,
    this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.skills,
    required this.friendRequestsSentIds,
    required this.education,
    required this.experience,
    required this.jobApplications,
    required this.jobPosts,
    this.github,
    this.twitter,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profileId: json['profileId'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      profilePicture:
          json['profilePicture'] != null
              ? ProfilePicture.fromJson(json['profilePicture'])
              : null,
      firstName: json['firstName'],
      lastName: json['lastName'],
      dob: json['dob'],
      gender: json['gender'],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((skillJson) => Skill.fromJson(skillJson))
              .toList() ??
          [],
      friendRequestsSentIds: List<String>.from(
        json['friendRequestsSentIds'] ?? [],
      ),
      education:
          (json['education'] as List<dynamic>?)
              ?.map((eduJson) => Education.fromJson(eduJson))
              .toList() ??
          [],
      experience:
          (json['experience'] as List<dynamic>?)
              ?.map((expJson) => Experience.fromJson(expJson))
              .toList() ??
          [],
      jobApplications: json['jobApplications'] ?? [],
      jobPosts: json['jobPosts'] ?? [],
      github: json['github'],
      twitter: json['twitter'] ?? json['x'],
    );
  }
}

class ProfilePicture {
  final String publicId;
  final String secureUrl;

  ProfilePicture({required this.publicId, required this.secureUrl});

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      publicId: json['public_id'],
      secureUrl: json['secure_url'],
    );
  }
}

class Skill {
  final String skill; // Changed from 'name' to 'skill'
  final bool verified;
  final String id; // Changed from '_id' to 'id' for Dart naming convention

  Skill({required this.skill, required this.verified, required this.id});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      skill: json['skill'],
      verified: json['verified'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'skill': skill, 'verified': verified, '_id': id};
  }
}

class Education {
  final String? degree;
  final String? institution;
  final String? location;
  final String? id;

  Education({this.degree, this.institution, this.location, this.id});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      degree: json['degree'],
      institution: json['institution'],
      location: json['location'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (degree != null) 'degree': degree,
      if (institution != null) 'institution': institution,
      if (location != null) 'location': location,
      if (id != null) '_id': id,
    };
  }
}

class Experience {
  final String? title;
  final String? company;
  final ExperienceDuration? duration;
  final String? id;

  Experience({this.title, this.company, this.duration, this.id});

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      title: json['title'],
      company: json['company'],
      duration:
          json['duration'] != null
              ? ExperienceDuration.fromJson(json['duration'])
              : null,
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (company != null) 'company': company,
      if (duration != null) 'duration': duration!.toJson(),
      if (id != null) '_id': id,
    };
  }
}

class ExperienceDuration {
  final String from;
  final String to;

  ExperienceDuration({required this.from, required this.to});

  factory ExperienceDuration.fromJson(Map<String, dynamic> json) {
    return ExperienceDuration(from: json['from'], to: json['to']);
  }

  Map<String, dynamic> toJson() {
    return {'from': from, 'to': to};
  }
}
