import { Injectable } from '@nestjs/common';

export type User = {
  id: number;
  fullName: string;
  email: string;
  academicRank: string;
  title: string;
  departmentId: number;
  roleId: number;
  isActive: boolean;
};

@Injectable()
export class UsersService {
  private readonly users: User[] = [
    {
      id: 1,
      fullName: 'Dr. Ayşe Yılmaz',
      email: 'ayse.yilmaz@uni.edu',
      academicRank: 'Doçent',
      title: 'Dr. Öğr. Üyesi',
      departmentId: 1,
      roleId: 2,
      isActive: true,
    },
    {
      id: 2,
      fullName: 'Dr. Mehmet Demir',
      email: 'mehmet.demir@uni.edu',
      academicRank: 'Profesör',
      title: 'Prof. Dr.',
      departmentId: 1,
      roleId: 1,
      isActive: true,
    },
    {
      id: 3,
      fullName: 'Dr. Elif Korkmaz',
      email: 'elif.korkmaz@uni.edu',
      academicRank: 'Yardımcı Doçent',
      title: 'Dr. Öğr. Üyesi',
      departmentId: 1,
      roleId: 3,
      isActive: true,
    },
  ];

  findAll(filters?: { departmentId?: number; isActive?: boolean; search?: string }) {
    let list = [...this.users];

    if (filters?.departmentId) {
      list = list.filter((user) => user.departmentId === filters.departmentId);
    }

    if (filters?.isActive !== undefined) {
      list = list.filter((user) => user.isActive === filters.isActive);
    }

    if (filters?.search) {
      const term = filters.search.toLowerCase();
      list = list.filter(
        (user) =>
          user.fullName.toLowerCase().includes(term) ||
          user.email.toLowerCase().includes(term),
      );
    }

    return list;
  }

  findById(id: number) {
    return this.users.find((user) => user.id === id);
  }
}
