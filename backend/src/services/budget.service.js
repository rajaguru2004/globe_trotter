/**
 * Budget Service
 */

import prisma from '../config/database.js';
import { NotFoundError, ForbiddenError } from '../utils/errors.js';

export const calculateTripBudget = async (tripId, userId) => {
    const trip = await prisma.trip.findFirst({
        where: { id: tripId, userId },
        include: {
            stops: {
                include: {
                    city: true,
                    activities: {
                        select: {
                            id: true,
                            estimatedCost: true,
                            scheduledDate: true
                        }
                    },
                    expenses: {
                        select: {
                            id: true,
                            amount: true,
                            category: true,
                            expenseDate: true
                        }
                    }
                }
            }
        }
    });

    if (!trip) {
        throw new NotFoundError('Trip not found');
    }

    // Calculate totals
    let totalEstimated = 0;
    let totalActual = 0;
    const budgetByCity = [];
    const budgetByDay = {};
    const budgetByCategory = {
        STAY: 0,
        FOOD: 0,
        ACTIVITY: 0,
        TRANSPORT: 0
    };

    trip.stops.forEach(stop => {
        let cityEstimated = 0;
        let cityActual = 0;

        // Add estimated costs from activities
        stop.activities.forEach(activity => {
            if (activity.estimatedCost) {
                cityEstimated += activity.estimatedCost;
                totalEstimated += activity.estimatedCost;

                // Group by day
                const day = activity.scheduledDate.toISOString().split('T')[0];
                if (!budgetByDay[day]) budgetByDay[day] = { estimated: 0, actual: 0 };
                budgetByDay[day].estimated += activity.estimatedCost;
            }
        });

        // Add actual expenses
        stop.expenses.forEach(expense => {
            cityActual += expense.amount;
            totalActual += expense.amount;
            budgetByCategory[expense.category] += expense.amount;

            // Group by day
            const day = expense.expenseDate.toISOString().split('T')[0];
            if (!budgetByDay[day]) budgetByDay[day] = { estimated: 0, actual: 0 };
            budgetByDay[day].actual += expense.amount;
        });

        budgetByCity.push({
            cityId: stop.cityId,
            cityName: stop.city.name,
            estimated: cityEstimated,
            actual: cityActual,
            remaining: cityEstimated - cityActual
        });
    });

    return {
        tripId: trip.id,
        tripName: trip.name,
        totalEstimated,
        totalActual,
        totalRemaining: totalEstimated - totalActual,
        budgetByCity,
        budgetByDay: Object.entries(budgetByDay).map(([date, budget]) => ({
            date,
            ...budget,
            remaining: budget.estimated - budget.actual
        })),
        budgetByCategory
    };
};
