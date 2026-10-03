import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ApiBearerAuth, ApiOperation, ApiTags, ApiResponse } from '@nestjs/swagger';

import { DashboardService } from './dashboard.service';

@ApiTags('Dashboard')
@ApiBearerAuth()
@UseGuards(AuthGuard('jwt'))
@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get('department-head')
  @ApiOperation({ 
    summary: 'Bölüm Başkanı Dashboard',
    description: 'Bölüm başkanı için performans özeti ve personel listesi'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Bölüm başkanı dashboard verisi',
    schema: {
      example: {
        summary: {
          totalStaff: 4,
          avgTotalScore: 80.35,
          avgTeachingScore: 85.25,
          avgResearchScore: 80.0,
          avgServiceScore: 77.0,
          totalPublications: 19,
          totalProjects: 8,
          goalCompletionRate: 74,
        },
        staffPerformance: [
          {
            id: 1,
            fullName: 'Dr. Ayşe Yılmaz',
            academicRank: 'Doçent',
            totalScore: 81.1,
            teachingScore: 88,
            researchScore: 82,
            serviceScore: 78,
            adminScore: 72,
            courseCount: 3,
            publicationCount: 5,
            advisingCount: 4,
          },
        ],
        alerts: [
          {
            type: 'research',
            message: '2 personel araştırma hedeflerini tamamlamadı.',
            severity: 'medium',
          },
        ],
      },
    }
  })
  getDepartmentHeadDashboard() {
    return this.dashboardService.getDepartmentHeadDashboard();
  }

  @Get('dean')
  @ApiOperation({ 
    summary: 'Dekan Dashboard',
    description: 'Dekan için tüm bölümlerin performans özeti'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Dekan dashboard verisi',
    schema: {
      example: {
        summary: {
          overallAvgScore: 80.35,
          totalDepartments: 1,
          totalStaff: 4,
        },
        departments: [
          {
            departmentId: 1,
            departmentName: 'Bilgisayar Mühendisliği',
            avgScore: 80.35,
            totalStaff: 4,
            publicationCount: 19,
            projectCount: 8,
          },
        ],
      },
    }
  })
  getDeanDashboard() {
    return this.dashboardService.getDeanDashboard();
  }
}
